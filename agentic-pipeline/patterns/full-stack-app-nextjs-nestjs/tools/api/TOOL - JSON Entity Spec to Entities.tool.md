# TOOL — JSON Entitiy Spec to Entities

Purpose
Generate NestJS + TypeORM entity classes from a JSON Entity Schema that defines domain entities, including columns, PK/FK, uniques, and indexes. Output files are placed under project-root/api/src/{{domain}}/entities and are ready to use with TypeOrmModule.forFeature(\[...]) and migrations.

Contract

* Inputs

    * spec (object | file path): JSON Schema containing named definitions
    * domain (string): short domain name used in paths (e.g., customer)
    * dbSchema (string | undefined): optional SQL schema/catalog; if provided, set in @Entity({ schema })
    * outDir (string): output dir, default project-root/api/src/{{domain}}/entities
    * idStrategy (object, optional): per-type PK defaults, e.g., { uuidDefault: "db" | "orm" }
    * engine (optional, string): target engine hints for edge cases ("postgres" | "mysql" | "mssql" | "oracle"); only affects migration notes or optional defaults (never required)
* Outputs

    * One .entity.ts per definition under outDir
    * Deterministic class names (PascalCase of definition names) and snake\_case column names
    * Decorators for @Entity, @Column, PKs, FKs (@ManyToOne, @JoinColumn), @Unique, @Index (with optional where when supported)

Authoritative Paths

* project-root/api/src/{{domain}}/entities

Assumptions

* JSON Schema uses definitions where each definition represents a table-like object.
* x-db extensions carry relational metadata:

    * primaryKey: string\[] (columns)
    * foreignKey: { column: string, ref: "OtherDef.column" }\[]
    * unique: string\[]\[] (composite allowed)
    * indexes: (string\[] | { columns: string\[], predicate?: string })\[]
* Required array indicates NOT NULL columns (except where a business rule requires nullable).
* Date-time fields map to timestamptz-ish types via TypeORM abstractions; exact SQL type resolved by driver.

Mapping Rules

* Name resolution

    * ClassName = PascalCase(defName), table name = pluralized snake\_case of defName by default. If you don’t want pluralization, disable in config.
    * Column names remain as-is from schema (typically snake\_case).
    * @Entity({ name, schema?: dbSchema })
* Scalar types

    * string (format: uuid) → 'uuid'
    * string (format: date-time) → @CreateDateColumn/@UpdateDateColumn if named created\_at/updated\_at; otherwise Column('timestamptz' | 'timestamp')
    * string with maxLength → Column('varchar', { length })
    * string fixed 2-char country → Column('char', { length: 2 })
    * integer → Column('integer')
    * boolean → Column('boolean')
* Nullability

    * required includes column → nullable: false
    * else → nullable: true
* Primary keys

    * If PK single integer → @PrimaryGeneratedColumn({ type: 'integer' })
    * If PK uuid:

        * idStrategy.uuidDefault = 'db' → @Column('uuid', { primary: true, default: () => engine==='postgres'?'gen\_random\_uuid()':'uuid\_generate\_v4()' /\* or omit \*/ })
        * idStrategy.uuidDefault = 'orm' (default) → @PrimaryGeneratedColumn('uuid')
    * Composite PKs → @PrimaryColumn for each component (no @PrimaryGeneratedColumn)
* Foreign keys

    * For each { column, ref: "OtherDef.column" }:

        * Add @Column for FK column
        * Add @ManyToOne(() => OtherDefClass, { onDelete: 'SET NULL' | 'CASCADE' (not inferred unless specified elsewhere) })
        * @JoinColumn({ name: column, referencedColumnName: '...' })
* Uniques

    * @Unique('ux\_<table>\_\<cols\_joined>', \['colA', 'colB'])
* Indexes

    * @Index('ix\_<table>\_<col>', \['col'])
    * Partial/filtered index: if predicate available and engine === 'postgres', use @Index(..., { where: '<predicate>' }); else skip or emit migration-only note.
* Relations (reverse)

    * If A has FK to B, generator may optionally emit @OneToMany on B referencing A; enable with flag addInverseRelations (default true)
* Timestamps

    * created\_at → @CreateDateColumn({ type: 'timestamptz' })
    * updated\_at → @UpdateDateColumn({ type: 'timestamptz' })
* Validation (optional)

    * If generateDto: true, emit DTOs with class-validator from the same JSON rules (not part of this tool’s core output unless requested)

CLI Usage (example)

* npx ts-node tools/json-spec-to-entities.ts --spec libs/domain/Customer\_domain.json --domain customer --dbSchema customer\_domain --outDir api/src/customer/entities --engine postgres

Reference Implementation (single-file generator)
tools/json-spec-to-entities.ts

```ts
#!/usr/bin/env ts-node
import * as fs from 'fs';
import * as path from 'path';

type JsonSchema = {
  definitions?: Record<string, any>;
  [k: string]: any;
};

type ToolConfig = {
  specPath: string;
  domain: string;
  dbSchema?: string;
  outDir: string;
  engine?: 'postgres' | 'mysql' | 'mssql' | 'oracle';
  idStrategy?: { uuidDefault?: 'orm' | 'db'; pluralizeTables?: boolean; addInverseRelations?: boolean };
};

const DEFAULTS = {
  idStrategy: { uuidDefault: 'orm' as const, pluralizeTables: true, addInverseRelations: true },
};

function pascalCase(s: string) {
  return s.replace(/[_-]+/g, ' ').replace(/\s+./g, m => m.trim().toUpperCase()).replace(/^\w/, c => c.toUpperCase()).replace(/\s/g, '');
}

function snakePlural(s: string) {
  const snake = s.replace(/([a-z0-9])([A-Z])/g, '$1_$2').toLowerCase();
  // naive pluralization: add 's' unless already ends with s
  return snake.endsWith('s') ? snake : `${snake}s`;
}

function tsTypeFromSchema(p: any): { columnType: string; tsType: string; columnOpts: string; decorator: 'Column' | 'CreateDateColumn' | 'UpdateDateColumn' } {
  if (p?.type === 'string' && p?.format === 'uuid') return { columnType: 'uuid', tsType: 'string', columnOpts: '', decorator: 'Column' };
  if (p?.type === 'string' && p?.format === 'date-time') return { columnType: 'timestamptz', tsType: 'Date', columnOpts: '', decorator: 'Column' };
  if (p?.type === 'string' && typeof p?.maxLength === 'number') return { columnType: `varchar`, tsType: 'string', columnOpts: `, length: ${p.maxLength}`, decorator: 'Column' };
  if (p?.type === 'string' && p?.minLength === 2 && p?.maxLength === 2) return { columnType: 'char', tsType: 'string', columnOpts: `, length: 2`, decorator: 'Column' };
  if (p?.type === 'string') return { columnType: 'text', tsType: 'string', columnOpts: '', decorator: 'Column' };
  if (p?.type === 'integer') return { columnType: 'integer', tsType: 'number', columnOpts: '', decorator: 'Column' };
  if (p?.type === 'boolean') return { columnType: 'boolean', tsType: 'boolean', columnOpts: '', decorator: 'Column' };
  return { columnType: 'text', tsType: 'any', columnOpts: '', decorator: 'Column' };
}

function emitEntity(defName: string, def: any, cfg: ToolConfig, allDefs: Record<string, any>) {
  const className = pascalCase(defName);
  const tableName = (cfg.idStrategy?.pluralizeTables ?? DEFAULTS.idStrategy.pluralizeTables) ? snakePlural(defName) : defName.replace(/([a-z0-9])([A-Z])/g, '$1_$2').toLowerCase();
  const required: string[] = def?.required ?? [];
  const props: Record<string, any> = def?.properties ?? {};
  const xdb = def?.['x-db'] ?? {};
  const pkCols: string[] = Array.isArray(xdb.primaryKey) ? xdb.primaryKey : [];
  const uniques: string[][] = Array.isArray(xdb.unique) ? xdb.unique : [];
  const fks: Array<{ column: string; ref: string }> = Array.isArray(xdb.foreignKey) ? xdb.foreignKey : [];
  const indexes: Array<any> = Array.isArray(xdb.indexes) ? xdb.indexes : [];

  const imports = new Set<string>(['Entity', 'Column']);
  const lines: string[] = [];

  // header imports
  const addImport = (s: string) => imports.add(s);

  // entity decorator
  lines.push(`@Entity({ name: '${tableName}'${cfg.dbSchema ? `, schema: '${cfg.dbSchema}'` : ''} })`);

  // indexes from x-db
  for (const ix of indexes) {
    if (Array.isArray(ix)) {
      const name = `ix_${tableName}_${ix.join('_')}`;
      lines.unshift(`@Index('${name}', [${ix.map(c => `'${c}'`).join(', ')}])`);
      addImport('Index');
    } else if (ix && Array.isArray(ix.columns)) {
      const name = `ix_${tableName}_${ix.columns.join('_')}`;
      if (ix.predicate) { addImport('Index'); lines.unshift(`@Index('${name}', [${ix.columns.map((c: string) => `'${c}'`).join(', ')}], { where: ${JSON.stringify(ix.predicate)} })`); }
      else { addImport('Index'); lines.unshift(`@Index('${name}', [${ix.columns.map((c: string) => `'${c}'`).join(', ')}])`); }
    }
  }

  // uniques
  for (const u of uniques) {
    const name = `ux_${tableName}_${u.join('_')}`;
    lines.unshift(`@Unique('${name}', [${u.map(c => `'${c}'`).join(', ')}])`);
    addImport('Unique');
  }

  // class open
  lines.push(`export class ${className} {`);

  // columns
  for (const [col, schema] of Object.entries(props)) {
    const isRequired = required.includes(col);
    const t = tsTypeFromSchema(schema);
    let optional = isRequired ? '' : '?';
    let nullableOpt = isRequired ? '' : ', nullable: true';

    // timestamps upgrade to special decorators
    const isCreated = col === 'created_at';
    const isUpdated = col === 'updated_at';

    // PK handling
    const isPk = pkCols.includes(col);

    if (isPk) {
      // single integer pk → generated
      if (schema['type'] === 'integer' && pkCols.length === 1) {
        addImport('PrimaryGeneratedColumn');
        lines.push(`  @PrimaryGeneratedColumn({ name: '${col}', type: 'integer' })`);
        lines.push(`  ${col}!: number;`);
        continue;
      }
      // uuid pk
      if (schema['type'] === 'string' && schema['format'] === 'uuid') {
        const uuidMode = cfg.idStrategy?.uuidDefault ?? DEFAULTS.idStrategy.uuidDefault;
        if (uuidMode === 'orm' && pkCols.length === 1) {
          addImport('PrimaryGeneratedColumn');
          lines.push(`  @PrimaryGeneratedColumn('uuid', { name: '${col}' })`);
          lines.push(`  ${col}!: string;`);
          continue;
        } else {
          // DB default or composite
          addImport('PrimaryColumn');
          const defExpr = (uuidMode === 'db' && (cfg.engine === 'postgres')) ? `, default: () => 'gen_random_uuid()'` : '';
          lines.push(`  @PrimaryColumn('uuid', { name: '${col}'${defExpr} })`);
          lines.push(`  ${col}!: string;`);
          continue;
        }
      }
      // composite or non-generated pk
      addImport('PrimaryColumn');
      lines.push(`  @PrimaryColumn('${t.columnType}', { name: '${col}'${t.columnOpts} })`);
      lines.push(`  ${col}!: ${t.tsType};`);
      continue;
    }

    // created/updated special
    if (isCreated) {
      addImport('CreateDateColumn');
      lines.push(`  @CreateDateColumn({ name: '${col}', type: '${t.columnType}' })`);
      lines.push(`  ${col}!: Date;`);
      continue;
    }
    if (isUpdated) {
      addImport('UpdateDateColumn');
      lines.push(`  @UpdateDateColumn({ name: '${col}', type: '${t.columnType}' })`);
      lines.push(`  ${col}!: Date;`);
      continue;
    }

    // regular column
    addImport('Column');
    lines.push(`  @Column({ name: '${col}', type: '${t.columnType}'${t.columnOpts}${nullableOpt} })`);
    lines.push(`  ${col}${optional}: ${t.tsType};`);
  }

  // foreign keys → relations
  for (const fk of fks) {
    const [targetDef, targetCol] = fk.ref.split('.');
    const targetClass = pascalCase(targetDef);
    addImport('ManyToOne'); addImport('JoinColumn');
    lines.push('');
    lines.push(`  @ManyToOne(() => ${targetClass}, { nullable: true, onDelete: 'SET NULL' })`);
    lines.push(`  @JoinColumn({ name: '${fk.column}', referencedColumnName: '${targetCol}' })`);
    lines.push(`  ${targetDef.replace(/([A-Z])/g, '_$1').toLowerCase()}?: ${targetClass} | null;`);
  }

  lines.push('}');

  // build import line
  const importList = Array.from(imports).sort();
  const head = `import { ${importList.join(', ')} } from 'typeorm';`;

  // relation imports (basic heuristic)
  const relImports = new Set<string>();
  for (const fk of fks) {
    const targetClass = pascalCase(fk.ref.split('.')[0]);
    relImports.add(`import { ${targetClass} } from './${snakePlural(fk.ref.split('.')[0]).replace(/s$/, '')}.entity';`);
  }

  const entitySource = [
    head,
    ...Array.from(relImports),
    '',
    ...lines,
    '',
  ].join('\n');

  const filename = path.join(cfg.outDir, `${defName.replace(/([a-z0-9])([A-Z])/g, '$1_$2').toLowerCase()}.entity.ts`);
  fs.mkdirSync(cfg.outDir, { recursive: true });
  fs.writeFileSync(filename, entitySource);
  return { className, filename };
}

function main() {
  // crude arg parsing
  const args = process.argv.slice(2);
  const get = (k: string) => {
    const i = args.findIndex(a => a === `--${k}`);
    return i >= 0 ? args[i + 1] : undefined;
  };
  const specPath = get('spec')!;
  const domain = get('domain')!;
  const outDir = get('outDir') ?? path.resolve('api', 'src', domain, 'entities');
  const dbSchema = get('dbSchema');
  const engine = get('engine') as ToolConfig['engine'] | undefined;
  const uuidDefault = (get('uuidDefault') as 'orm' | 'db') ?? 'orm';

  const cfg: ToolConfig = { specPath, domain, outDir, dbSchema, engine, idStrategy: { uuidDefault, pluralizeTables: true, addInverseRelations: true } };

  const raw = fs.readFileSync(specPath, 'utf-8');
  const spec: JsonSchema = JSON.parse(raw);
  const defs = spec.definitions ?? {};
  if (!Object.keys(defs).length) {
    throw new Error('No definitions found in spec.definitions');
  }

  const results: Array<{ className: string; filename: string }> = [];
  for (const [defName, def] of Object.entries(defs)) {
    if (def?.type !== 'object') continue;
    results.push(emitEntity(defName, def, cfg, defs));
  }

  // optional inverse relations pass (not shown: scan FKs and add @OneToMany on targets)
  console.log(`Emitted ${results.length} entities to ${outDir}`);
}

if (require.main === module) main();
```

Generator Behavior Notes

* Partial/filtered indexes: supported via @Index({ where }) on Postgres. For other engines, either ignore the predicate or move it into a vendor-specific migration (separate tool).
* UUID defaults:

    * orm: @PrimaryGeneratedColumn('uuid') (works across engines that map UUID or uniqueidentifier)
    * db: use database default function. Postgres example shown; for others, omit the default and generate in app or via trigger.
* Timestamps: CreateDateColumn/UpdateDateColumn map to engine-appropriate timestamp types.
* Composite PKs: emitted via multiple @PrimaryColumn entries.

Quality Gates

* Deterministic output: same spec → same files.
* Idempotence: re-running overwrites files. Place them under VCS and review diffs.
* Lint/format: run your existing ESLint/Prettier after generation.

Next Steps

* Run the generator on your schema into project-root/api/src/customer/entities.
* Wire ORM config and migrations with the Configure ORM for SQL tool.
* Implement repository-backed services with the Create Service for Persistence tool.
