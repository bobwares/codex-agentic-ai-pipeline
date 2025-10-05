================
CODE SNIPPETS
================
TITLE: Create a new TanStack Start project
DESCRIPTION: Initializes a new TanStack Start project named 'my-project' and navigates into its directory, using the `create-start-app` command-line tool. This is the first step before installing other dependencies.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/tanstack-start

LANGUAGE: bash
CODE:
```
npx create-start-app@latest my-project
cd my-project
```

--------------------------------

TITLE: Basic HTML structure with Tailwind CSS classes
DESCRIPTION: This HTML example demonstrates a basic page setup, including the necessary meta tags and a link to the compiled CSS file. It also shows a heading styled with Tailwind's utility classes like `text-3xl`, `font-bold`, and `underline`.

SOURCE: https://tailwindcss.com/docs/installation/using-postcss

LANGUAGE: HTML
CODE:
```
<!doctype html><html><head>  <meta charset="UTF-8">  <meta name="viewport" content="width=device-width, initial-scale=1.0">  <link href="/dist/styles.css" rel="stylesheet"></head><body>  <h1 class="text-3xl font-bold underline">    Hello world!  </h1></body></html>
```

--------------------------------

TITLE: Install Tailwind CSS and PostCSS dependencies via npm
DESCRIPTION: This command installs the necessary packages: `tailwindcss`, `@tailwindcss/postcss`, and `postcss` using npm. These are fundamental for integrating Tailwind CSS as a PostCSS plugin in your project.

SOURCE: https://tailwindcss.com/docs/installation/using-postcss

LANGUAGE: Shell
CODE:
```
npm install tailwindcss @tailwindcss/postcss postcss
```

--------------------------------

TITLE: Example HTML structure using Tailwind CSS classes
DESCRIPTION: A basic HTML document demonstrating how to link your compiled CSS file and apply Tailwind's utility classes to elements. Ensure your framework correctly includes the compiled stylesheet in the `<head>`.

SOURCE: https://tailwindcss.com/docs/index

LANGUAGE: HTML
CODE:
```
<!doctype html><html><head>  <meta charset="UTF-8">  <meta name="viewport" content="width=device-width, initial-scale=1.0">  <link href="/src/style.css" rel="stylesheet"></head><body>  <h1 class="text-3xl font-bold underline">    Hello world!  </h1></body></html>
```

--------------------------------

TITLE: Start Qwik development server
DESCRIPTION: Executes the `npm run dev` command to start the development server, which builds and serves the Qwik application, enabling live preview and hot module reloading.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/qwik

LANGUAGE: bash
CODE:
```
npm run dev
```

--------------------------------

TITLE: Start your development build process
DESCRIPTION: This command initiates your project's development build process, typically defined in your `package.json` scripts. It compiles your CSS, including Tailwind styles, and often starts a local development server.

SOURCE: https://tailwindcss.com/docs/installation/using-postcss

LANGUAGE: Shell
CODE:
```
npm run dev
```

--------------------------------

TITLE: Install Tailwind CSS and CLI via npm
DESCRIPTION: This command installs the core `tailwindcss` package along with the `@tailwindcss/cli` tool using npm. These packages are fundamental for leveraging the Tailwind CLI to process your CSS and generate utility classes.

SOURCE: https://tailwindcss.com/docs/installation/tailwind-cli

LANGUAGE: Terminal
CODE:
```
npm install tailwindcss @tailwindcss/cli
```

--------------------------------

TITLE: Start SvelteKit Development Server
DESCRIPTION: Executes the `npm run dev` command to start the SvelteKit development server. This allows developers to preview their application and utilize live reloading during development.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/sveltekit

LANGUAGE: Shell
CODE:
```
npm run dev
```

--------------------------------

TITLE: Start the Tailwind CLI build process with watch mode
DESCRIPTION: Execute this command to initiate the Tailwind CSS build. It scans your specified input CSS file (`./src/input.css`) and any linked HTML/JS files for Tailwind classes, then generates the final CSS output to `./src/output.css`. The `--watch` flag enables continuous rebuilding whenever source files change.

SOURCE: https://tailwindcss.com/docs/installation/tailwind-cli

LANGUAGE: Terminal
CODE:
```
npx @tailwindcss/cli -i ./src/input.css -o ./src/output.css --watch
```

--------------------------------

TITLE: Start the Vite development server
DESCRIPTION: Run the development server using `npm run dev`. This command compiles your assets, watches for changes, and serves your application locally, allowing you to see your Tailwind CSS styles in action.

SOURCE: https://tailwindcss.com/docs/index

LANGUAGE: Shell
CODE:
```
npm run dev
```

--------------------------------

TITLE: Start Ember.js development server
DESCRIPTION: Runs the `npm run start` command to initiate the Ember.js build process and start the development server. This allows you to view your application in a web browser and see the applied Tailwind CSS styles.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/emberjs

LANGUAGE: Terminal
CODE:
```
npm run start
```

--------------------------------

TITLE: Install Tailwind CSS and Vite plugin via npm
DESCRIPTION: Install the necessary `tailwindcss` and `@tailwindcss/vite` packages using npm. These packages are essential for integrating Tailwind CSS with your Vite build process.

SOURCE: https://tailwindcss.com/docs/index

LANGUAGE: Shell
CODE:
```
npm install tailwindcss @tailwindcss/vite
```

--------------------------------

TITLE: Start Astro development server
DESCRIPTION: Executes the `npm run dev` command to start the Astro development server, allowing you to preview your project and see Tailwind CSS styles applied in real-time.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/astro

LANGUAGE: Shell
CODE:
```
npm run dev
```

--------------------------------

TITLE: Create a new Vite project
DESCRIPTION: Initialize a new Vite project using `npm create vite@latest` and navigate into the project directory. This command sets up the basic project structure.

SOURCE: https://tailwindcss.com/docs/index

LANGUAGE: Shell
CODE:
```
npm create vite@latest my-project
cd my-project
```

--------------------------------

TITLE: Integrate compiled Tailwind CSS and use utility classes in HTML
DESCRIPTION: This HTML snippet demonstrates how to link the compiled `output.css` file in your document's `<head>` section. It also provides a basic example of applying Tailwind's utility classes (e.g., `text-3xl`, `font-bold`, `underline`) directly to an HTML element to style content.

SOURCE: https://tailwindcss.com/docs/installation/tailwind-cli

LANGUAGE: HTML
CODE:
```
<!doctype html><html><head>  <meta charset="UTF-8">  <meta name="viewport" content="width=device-width, initial-scale=1.0">  <link href="./output.css" rel="stylesheet"></head><body>  <h1 class="text-3xl font-bold underline">    Hello world!  </h1></body></html>
```

--------------------------------

TITLE: Install Tailwind CSS and Vite plugin
DESCRIPTION: Installs the core `tailwindcss` package and the `@tailwindcss/vite` plugin along with their peer dependencies via npm. These packages are essential for integrating Tailwind CSS with a Vite-based TanStack Start project.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/tanstack-start

LANGUAGE: bash
CODE:
```
npm install tailwindcss @tailwindcss/vite
```

--------------------------------

TITLE: Start Phoenix development server
DESCRIPTION: Run the `mix phx.server` command to start the Phoenix development server. This command also initiates the asset build process, including the compilation of your Tailwind CSS.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/phoenix

LANGUAGE: Shell
CODE:
```
mix phx.server
```

--------------------------------

TITLE: Start Development Server
DESCRIPTION: Executes the `npm run dev` command, which typically starts the development server configured by Vite, enabling live reloading and local preview of the application.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/react-router

LANGUAGE: shell
CODE:
```
npm run dev
```

--------------------------------

TITLE: Start the Vite development server
DESCRIPTION: Run the development server using `npm run dev`. This command compiles your project, processes Tailwind CSS, and serves your application with live reloading capabilities.

SOURCE: https://tailwindcss.com/docs/installation

LANGUAGE: bash
CODE:
```
npm run dev
```

--------------------------------

TITLE: Start Gatsby development server
DESCRIPTION: Runs the `gatsby develop` command to start the local development server. This compiles the project and provides a live-reloading environment for development.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/gatsby

LANGUAGE: bash
CODE:
```
gatsby develop
```

--------------------------------

TITLE: Start the Next.js development server
DESCRIPTION: This command initiates the Next.js development server, which compiles your project and provides a live-reloading environment for local development and testing.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/nextjs

LANGUAGE: Shell
CODE:
```
npm run dev
```

--------------------------------

TITLE: Start Rspack Development Server
DESCRIPTION: Execute the `npm run dev` command to start the Rspack development server. This compiles your project, applies Tailwind CSS, and provides a live-reloading environment for development.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/rspack/react

LANGUAGE: Shell
CODE:
```
npm run dev
```

--------------------------------

TITLE: Create a new Nuxt project
DESCRIPTION: Start by creating a new Nuxt project using `create-nuxt` if you don’t have one set up already. This command initializes a new Nuxt application and navigates into its directory.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/nuxt

LANGUAGE: Shell
CODE:
```
npm create nuxt my-project
cd my-project
```

--------------------------------

TITLE: Import Tailwind CSS into your main CSS file
DESCRIPTION: Add this `@import` statement to your project's main CSS file (e.g., `src/input.css`). This line tells Tailwind to inject its base styles, components, and utility classes into your stylesheet during the build process.

SOURCE: https://tailwindcss.com/docs/installation/tailwind-cli

LANGUAGE: CSS
CODE:
```
@import "tailwindcss";
```

--------------------------------

TITLE: Create a new Qwik project
DESCRIPTION: Initializes a new Qwik project using `create-qwik` and navigates into the newly created project directory.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/qwik

LANGUAGE: bash
CODE:
```
npm create qwik@latest empty my-project
cd my-project
```

--------------------------------

TITLE: Start Nuxt development server
DESCRIPTION: Run the development server using `npm run dev`. This command starts your Nuxt application, allowing you to see the changes and use Tailwind CSS for styling.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/nuxt

LANGUAGE: Shell
CODE:
```
npm run dev
```

--------------------------------

TITLE: Start the development build process
DESCRIPTION: Initiates the development server using `npm run dev`, which compiles the SolidJS application with Tailwind CSS. This command provides live reloading, allowing developers to see changes instantly.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/solidjs

LANGUAGE: Shell
CODE:
```
npm run dev
```

--------------------------------

TITLE: Add Tailwind CSS PostCSS plugin to configuration
DESCRIPTION: This configuration snippet for `postcss.config.mjs` (or your PostCSS configuration file) adds the `@tailwindcss/postcss` plugin to your PostCSS setup. This enables PostCSS to correctly process and compile Tailwind CSS directives.

SOURCE: https://tailwindcss.com/docs/installation/using-postcss

LANGUAGE: JavaScript
CODE:
```
export default {  plugins: {    "@tailwindcss/postcss": {},  }}
```

--------------------------------

TITLE: Create SvelteKit Project
DESCRIPTION: Initializes a new SvelteKit project using the `npx sv create` command and then navigates into the newly created project directory.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/sveltekit

LANGUAGE: Shell
CODE:
```
npx sv create my-project
cd my-project
```

--------------------------------

TITLE: Start the Meteor project build process
DESCRIPTION: This command initiates the development server and build process for the Meteor application. It allows for real-time compilation and serving of the project, enabling live development.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/meteor

LANGUAGE: Shell
CODE:
```
npm run start
```

--------------------------------

TITLE: Integrate Tailwind CSS Play CDN in HTML
DESCRIPTION: This example demonstrates how to include the Tailwind CSS Play CDN script in the <head> section of an HTML file. This setup allows for immediate use of Tailwind's utility classes for development purposes without a build step.

SOURCE: https://tailwindcss.com/docs/installation/play-cdn

LANGUAGE: HTML
CODE:
```
<!doctype html><html>  <head>    <meta charset="UTF-8" />    <meta name="viewport" content="width=device-width, initial-scale=1.0" />    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>  </head>  <body>    <h1 class="text-3xl font-bold underline">      Hello world!    </h1>  </body></html>
```

--------------------------------

TITLE: Basic HTML structure with Tailwind CSS classes
DESCRIPTION: An example HTML file demonstrating how to link your compiled stylesheet and apply Tailwind's utility classes to elements for styling. Ensure the `href` attribute points to your generated CSS file.

SOURCE: https://tailwindcss.com/docs/installation

LANGUAGE: html
CODE:
```
<!doctype html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="/src/style.css" rel="stylesheet">
</head>
<body>
  <h1 class="text-3xl font-bold underline">
    Hello world!
  </h1>
</body>
</html>
```

--------------------------------

TITLE: Start Rspack Development Server
DESCRIPTION: Initiates the Rspack development server, compiling and serving the project, typically with hot-reloading capabilities.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/rspack/vue

LANGUAGE: Shell
CODE:
```
npm run dev
```

--------------------------------

TITLE: Start Parcel build process
DESCRIPTION: This command initiates Parcel's development server and build process, compiling the index.html file and its dependencies. It allows for live reloading and development.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/parcel

LANGUAGE: bash
CODE:
```
npx parcel src/index.html
```

--------------------------------

TITLE: Create a New Rspack Project
DESCRIPTION: Initializes a new Rspack project using the Rspack CLI, providing a foundational setup for development.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/rspack/vue

LANGUAGE: Shell
CODE:
```
npm create rspack@latest
```

--------------------------------

TITLE: Use Tailwind CSS utility classes in a component
DESCRIPTION: Demonstrates how to apply Tailwind CSS utility classes directly within JSX. This example shows an `<h1>` element styled with `text-3xl` for font size, `font-bold` for weight, and `underline` for text decoration.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/tanstack-start

LANGUAGE: typescript
CODE:
```
import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/')({
  component: App,
})

function App() {
  return (
    <h1 class="text-3xl font-bold underline">
      Hello World!
    </h1>
  )}

```

--------------------------------

TITLE: Import CSS file in TanStack Start root route
DESCRIPTION: Imports the application's main CSS file (`styles.css`) into the `__root.tsx` component using the `?url` query parameter. It then links this CSS file as a stylesheet in the document's head via the `links` property of the `head` configuration.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/tanstack-start

LANGUAGE: typescript
CODE:
```
// other imports...
import appCss from '../styles.css?url'

export const Route = createRootRoute({
  head: () => ({
    meta: [
      // your meta tags and site config
    ],
    links: [{ rel: 'stylesheet', href: appCss }],
    // other head config
  }),
  component: RootComponent,
})
```

--------------------------------

TITLE: Start the development build process
DESCRIPTION: Run the development build command to compile your assets, including Tailwind CSS. This command typically watches for file changes and rebuilds automatically during development.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/laravel/vite

LANGUAGE: bash
CODE:
```
npm run dev
```

--------------------------------

TITLE: Create a new Laravel project
DESCRIPTION: Initiate a new Laravel project using the Laravel installer command. This command sets up the basic project structure and navigates into the new directory.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/laravel/vite

LANGUAGE: bash
CODE:
```
laravel new my-project
cd my-project
```

--------------------------------

TITLE: Create a new Phoenix project
DESCRIPTION: Instructions to initialize a new Phoenix project using the `mix phx.new` command and then navigate into the newly created project directory.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/phoenix

LANGUAGE: Shell
CODE:
```
mix phx.new myproject
cd myproject
```

--------------------------------

TITLE: Create a new Ruby on Rails project
DESCRIPTION: Initializes a new Ruby on Rails application with a specified name and then navigates into the newly created project directory. This command is typically the first step when starting a new Rails development.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/ruby-on-rails

LANGUAGE: Shell
CODE:
```
rails new my-project
cd my-project
```

--------------------------------

TITLE: Import Tailwind CSS into the main stylesheet
DESCRIPTION: Adds an `@import` statement to the `src/styles.css` file. This line pulls in all of Tailwind's base styles, components, and utilities, making them available throughout the application.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/tanstack-start

LANGUAGE: css
CODE:
```
@import "tailwindcss";
```

--------------------------------

TITLE: Start Angular development server
DESCRIPTION: Runs the Angular development server using `ng serve`. This command compiles your application, serves it locally, and enables live reloading, allowing you to see changes as you develop.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/angular

LANGUAGE: bash
CODE:
```
ng serve
```

--------------------------------

TITLE: Create a new Astro project
DESCRIPTION: Initializes a new Astro project using the `create astro` command and navigates into the newly created project directory.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/astro

LANGUAGE: Shell
CODE:
```
npm create astro@latest my-project
cd my-project
```

--------------------------------

TITLE: Initialize a new Parcel project
DESCRIPTION: This step outlines how to set up a new Parcel project from scratch, including creating directories and initializing npm. It prepares the environment for installing Tailwind CSS.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/parcel

LANGUAGE: bash
CODE:
```
mkdir my-project
cd my-project
npm init -y
npm install parcel
mkdir src
touch src/index.html
```

--------------------------------

TITLE: Start the development build process
DESCRIPTION: Executes the `npm run dev` command to initiate the development server and asset build process. This command compiles all project assets, including the Tailwind CSS, for local development.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/adonisjs

LANGUAGE: Shell
CODE:
```
npm run dev
```

--------------------------------

TITLE: Configure Vite to use Tailwind CSS plugin
DESCRIPTION: Modifies the `vite.config.ts` file to include the `@tailwindcss/vite` plugin in the `plugins` array. This ensures that Vite correctly processes Tailwind CSS during the build and development cycles.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/tanstack-start

LANGUAGE: typescript
CODE:
```
import { tanstackStart } from '@tanstack/react-start/plugin/vite';
import { defineConfig } from 'vite';
import tsConfigPaths from 'vite-tsconfig-paths';
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    tailwindcss(),
    tanstackStart(),
    tsConfigPaths(),
  ]
});
```

--------------------------------

TITLE: Install Tailwind CSS and Vite plugin for Qwik
DESCRIPTION: Installs the core `tailwindcss` package and the `@tailwindcss/vite` plugin, along with their necessary peer dependencies, using npm.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/qwik

LANGUAGE: bash
CODE:
```
npm install tailwindcss @tailwindcss/vite
```

--------------------------------

TITLE: Start Laravel Mix build process with npm
DESCRIPTION: This command initiates the Laravel Mix build process, typically in watch mode, to compile assets including Tailwind CSS. It continuously monitors for changes and rebuilds the project as needed during development.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/laravel/mix

LANGUAGE: bash
CODE:
```
npm run watch
```

--------------------------------

TITLE: Start Webpack Encore build process
DESCRIPTION: Initiates the Webpack Encore build process in watch mode by running `npm run watch`. This command compiles your assets, including Tailwind CSS, and automatically rebuilds them whenever changes are detected in your source files.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/symfony

LANGUAGE: Shell
CODE:
```
npm run watch
```

--------------------------------

TITLE: Install Tailwind CSS CLI
DESCRIPTION: Execute the `mix tailwind.install` command to download and set up the standalone Tailwind CSS command-line interface (CLI) executable within your project.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/phoenix

LANGUAGE: Shell
CODE:
```
mix tailwind.install
```

--------------------------------

TITLE: Create a new Symfony project
DESCRIPTION: Initializes a new Symfony web application using the Symfony Installer and navigates into the newly created project directory. This is the foundational step before integrating front-end tools.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/symfony

LANGUAGE: Shell
CODE:
```
symfony new --webapp my-project
cd my-project
```

--------------------------------

TITLE: Import Tailwind CSS into your main CSS file
DESCRIPTION: This `@import` rule should be added to your main CSS file (e.g., `src/index.css`). It instructs PostCSS to include Tailwind's base styles, components, and utility classes into your final compiled CSS.

SOURCE: https://tailwindcss.com/docs/installation/using-postcss

LANGUAGE: CSS
CODE:
```
@import "tailwindcss";
```

--------------------------------

TITLE: Create a new SolidJS project using Vite
DESCRIPTION: Initializes a new SolidJS project with the Vite template using `npx degit`. This command sets up the basic project structure and navigates into the newly created directory, preparing it for further development.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/solidjs

LANGUAGE: Shell
CODE:
```
npx degit solidjs/templates/js my-project
cd my-project
```

--------------------------------

TITLE: Create a new AdonisJS project
DESCRIPTION: Initializes a new AdonisJS project using the `create adonisjs` command with the `web` kit and then navigates into the newly created project directory.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/adonisjs

LANGUAGE: Shell
CODE:
```
npm init adonisjs@latest my-project -- --kit=web
cd my-project
```

--------------------------------

TITLE: Import Tailwind CSS into your main CSS file
DESCRIPTION: Add the `@import "tailwindcss";` directive to your primary CSS file. This line imports all of Tailwind's base styles, components, and utilities.

SOURCE: https://tailwindcss.com/docs/index

LANGUAGE: CSS
CODE:
```
@import "tailwindcss";
```

--------------------------------

TITLE: Start the development build process for Ruby on Rails
DESCRIPTION: Initiates the development server and asset compilation process for the Ruby on Rails application. This command typically watches for file changes and rebuilds assets, including Tailwind CSS, ensuring that styles are applied correctly during development.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/ruby-on-rails

LANGUAGE: Shell
CODE:
```
./bin/dev
```

--------------------------------

TITLE: Initialize a new Vite project
DESCRIPTION: Use the npm create vite command to scaffold a new Vite project interactively. After creation, navigate into the newly created project directory.

SOURCE: https://tailwindcss.com/docs/installation

LANGUAGE: bash
CODE:
```
npm create vite@latest my-project
cd my-project
```

--------------------------------

TITLE: Create React Router Project
DESCRIPTION: Initializes a new React Router project using the `create-react-router` command-line tool and then navigates into the newly created project directory.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/react-router

LANGUAGE: shell
CODE:
```
npx create-react-router@latest my-project
cd my-project
```

--------------------------------

TITLE: Install Tailwind CSS and Vite Plugin
DESCRIPTION: Installs the core `tailwindcss` package and its SvelteKit-specific Vite plugin, `@tailwindcss/vite`, as development dependencies using npm.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/sveltekit

LANGUAGE: Shell
CODE:
```
npm install tailwindcss @tailwindcss/vite
```

--------------------------------

TITLE: Apply Responsive Justify Content in Tailwind CSS
DESCRIPTION: Demonstrates how to use Tailwind CSS utility classes to apply responsive `justify-content` styling. The example shows a flex container that starts with `justify-start` and switches to `justify-between` on medium screens and larger, illustrating conditional styling based on screen size.

SOURCE: https://tailwindcss.com/docs/justify-content

LANGUAGE: html
CODE:
```
<div class="flex justify-start md:justify-between ...">  <!-- ... --></div>
```

--------------------------------

TITLE: Apply Tailwind CSS place-items Responsively
DESCRIPTION: This example demonstrates how to apply `place-items` utilities in Tailwind CSS, using a responsive variant (`md:`) to change alignment behavior based on screen size. It shows a `div` element with a grid layout that initially places items at the start and then centers them on medium screens and above.

SOURCE: https://tailwindcss.com/docs/place-items

LANGUAGE: html
CODE:
```
<div class="grid place-items-start md:place-items-center ...">  <!-- ... --></div>
```

--------------------------------

TITLE: Install Tailwind CSS gems for Ruby on Rails
DESCRIPTION: Adds the `tailwindcss-ruby` and `tailwindcss-rails` gems to the project's Gemfile, making them available for use. Following the gem installation, the `tailwindcss:install` command is executed to set up the necessary configuration files and assets for Tailwind CSS within the Rails application.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/ruby-on-rails

LANGUAGE: Shell
CODE:
```
./bin/bundle add tailwindcss-ruby
./bin/bundle add tailwindcss-rails
./bin/rails tailwindcss:install
```

--------------------------------

TITLE: Configure Tailwind CSS Vite plugin in vite.config.ts
DESCRIPTION: Add the `@tailwindcss/vite` plugin to your Vite configuration file (`vite.config.ts`). This step ensures that Tailwind CSS is processed correctly by Vite during development and build.

SOURCE: https://tailwindcss.com/docs/index

LANGUAGE: TypeScript
CODE:
```
import { defineConfig } from 'vite'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    tailwindcss(),
  ],
})
```

--------------------------------

TITLE: Use Tailwind CSS utility classes in Vue template
DESCRIPTION: Start applying Tailwind's utility classes directly in your Vue components to style your content. This example demonstrates a basic `h1` element styled with Tailwind classes for font size, weight, and text decoration.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/nuxt

LANGUAGE: Vue
CODE:
```
<template>
  <h1 class="text-3xl font-bold underline">
    Hello world!
  </h1>
</template>
```

--------------------------------

TITLE: Create a new Ember.js project
DESCRIPTION: Initializes a new Ember.js project using Ember CLI with Embroider and no welcome page, then navigates into the newly created project directory.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/emberjs

LANGUAGE: Terminal
CODE:
```
npx ember-cli new my-project --embroider --no-welcome
cd my-project
```

--------------------------------

TITLE: Create a New Rspack Project
DESCRIPTION: Initiate a new Rspack project using the Rspack CLI. This command sets up the basic project structure, ready for further configuration.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/rspack/react

LANGUAGE: Shell
CODE:
```
npm create rspack@latest
```

--------------------------------

TITLE: Create a new Next.js project with TypeScript and ESLint
DESCRIPTION: This command initializes a new Next.js application using `create-next-app`, configuring it with TypeScript, ESLint, and the App Router. After creation, it navigates into the new project directory.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/nextjs

LANGUAGE: Shell
CODE:
```
npx create-next-app@latest my-project --typescript --eslint --app
cd my-project
```

--------------------------------

TITLE: Enable Tailwind watcher in Phoenix development
DESCRIPTION: Add the Tailwind watcher to the list of development watchers in your `config/dev.exs` file. This setup automatically recompiles your Tailwind CSS whenever changes are detected during development.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/phoenix

LANGUAGE: Elixir
CODE:
```
watchers: [
  # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
  esbuild: {Esbuild, :install_and_run, [:myproject, ~w(--sourcemap=inline --watch)]},
  tailwind: {Tailwind, :install_and_run, [:myproject, ~w(--watch)]}
]
```

--------------------------------

TITLE: Install Tailwind CSS and PostCSS Dependencies
DESCRIPTION: Install the core Tailwind CSS package (`tailwindcss`), the PostCSS plugin for Tailwind (`@tailwindcss/postcss`), and their necessary peer dependencies (`postcss`, `postcss-loader`) using npm.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/rspack/react

LANGUAGE: Shell
CODE:
```
npm install tailwindcss @tailwindcss/postcss postcss postcss-loader
```

--------------------------------

TITLE: Create a new Meteor project using npx
DESCRIPTION: This command initializes a new Meteor application with the specified project name and navigates into its directory, preparing the environment for further development.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/meteor

LANGUAGE: Shell
CODE:
```
npx meteor create my-project
cd my-project
```

--------------------------------

TITLE: Install Tailwind CSS and Vite plugin
DESCRIPTION: Installs the necessary npm packages for Tailwind CSS integration with Vite. This includes `tailwindcss` itself and `@tailwindcss/vite`, which is the official plugin for Vite, along with their peer dependencies.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/solidjs

LANGUAGE: Shell
CODE:
```
npm install tailwindcss @tailwindcss/vite
```

--------------------------------

TITLE: Apply Tailwind CSS classes in a SolidJS component
DESCRIPTION: Demonstrates how to use Tailwind's utility classes directly within a SolidJS component's JSX. This example applies text size, font weight, and underline styles to an `<h1>` element, showcasing immediate styling capabilities.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/solidjs

LANGUAGE: JavaScript
CODE:
```
export default function App() {  return (    <h1 class="text-3xl font-bold underline">      Hello world!    </h1>  )}
```

--------------------------------

TITLE: Install Tailwind CSS and PostCSS dependencies via npm
DESCRIPTION: This command installs the core `tailwindcss` package, the `@tailwindcss/postcss` plugin, and `postcss` itself as development dependencies required for Tailwind CSS integration in a Next.js project.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/nextjs

LANGUAGE: Shell
CODE:
```
npm install tailwindcss @tailwindcss/postcss postcss
```

--------------------------------

TITLE: Use Tailwind CSS classes in Phoenix HTML
DESCRIPTION: An example demonstrating how to apply Tailwind's utility classes directly within an HTML element in a Phoenix HEEX template. This shows basic styling for text size, weight, and decoration.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/phoenix

LANGUAGE: HTML
CODE:
```
<h1 class="text-3xl font-bold underline">  Hello world!</h1>
```

--------------------------------

TITLE: Create a new Gatsby project
DESCRIPTION: Initializes a new Gatsby project using the Gatsby CLI and navigates into the newly created project directory. This is the first step to set up your development environment.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/gatsby

LANGUAGE: bash
CODE:
```
gatsby new my-project
cd my-project
```

--------------------------------

TITLE: Install Tailwind CSS and Vite plugin for Laravel
DESCRIPTION: Install the necessary npm packages for Tailwind CSS and its Vite integration. This includes `tailwindcss` and `@tailwindcss/vite` as development dependencies.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/laravel/vite

LANGUAGE: bash
CODE:
```
npm install tailwindcss @tailwindcss/vite
```

--------------------------------

TITLE: Install Tailwind CSS and PostCSS dependencies
DESCRIPTION: Installs Tailwind CSS, its PostCSS plugin (`@tailwindcss/postcss`), and `postcss-loader` using npm. These packages are crucial for processing Tailwind's utility classes and integrating them into your build pipeline.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/symfony

LANGUAGE: Shell
CODE:
```
npm install tailwindcss @tailwindcss/postcss postcss postcss-loader
```

--------------------------------

TITLE: Sort Tailwind CSS classes with Prettier plugin
DESCRIPTION: This HTML example demonstrates the automatic class sorting provided by the official Prettier plugin for Tailwind CSS. It shows a button's class attribute before and after the plugin reorders the utility classes according to the recommended standard. This plugin works seamlessly with custom Tailwind configurations and any environment where Prettier is used.

SOURCE: https://tailwindcss.com/docs/editor-setup

LANGUAGE: HTML
CODE:
```
<!-- Before --><button class="text-white px-4 sm:px-8 py-2 sm:py-3 bg-sky-700 hover:bg-sky-800">Submit</button><!-- After --><button class="bg-sky-700 px-4 py-2 text-white hover:bg-sky-800 sm:px-8 sm:py-3">Submit</button>
```

--------------------------------

TITLE: Import Tailwind CSS into Qwik global stylesheet
DESCRIPTION: Adds an `@import` statement to the project's global CSS file (e.g., `./src/global.css` or `app.css`) to include all Tailwind CSS styles.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/qwik

LANGUAGE: css
CODE:
```
@import "tailwindcss";
```

--------------------------------

TITLE: Install Tailwind CSS and PostCSS with npm
DESCRIPTION: This command installs Tailwind CSS, `@tailwindcss/postcss`, and `postcss` as peer dependencies using npm. These packages are essential for compiling Tailwind CSS in a Laravel project.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/laravel/mix

LANGUAGE: bash
CODE:
```
npm install tailwindcss @tailwindcss/postcss postcss
```

--------------------------------

TITLE: Install Tailwind CSS and Vite Plugin
DESCRIPTION: Installs the core `tailwindcss` package and its dedicated Vite plugin (`@tailwindcss/vite`) along with their necessary peer dependencies using npm, preparing the project for Tailwind CSS integration.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/react-router

LANGUAGE: shell
CODE:
```
npm install tailwindcss @tailwindcss/vite
```

--------------------------------

TITLE: Import application CSS into Ember app
DESCRIPTION: Modifies the `./app/app.js` file to import the newly created `./app/app.css` file. This ensures that your main application stylesheet, including Tailwind CSS, is loaded and applied when the Ember application starts.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/emberjs

LANGUAGE: JavaScript
CODE:
```
import Application from '@ember/application';import Resolver from 'ember-resolver';import loadInitializers from 'ember-load-initializers';import config from 'my-project/config/environment';import 'my-project/app.css';export default class App {  modulePrefix = config.modulePrefix;  podModulePrefix = config.podModulePrefix;  Resolver = Resolver;}loadInitializers(App, config.modulePrefix);
```

--------------------------------

TITLE: Install Tailwind plugin in Phoenix dependencies
DESCRIPTION: Add the Tailwind plugin to your Phoenix project's dependencies in `mix.exs` and then run `mix deps.get` to fetch and install it. The plugin is configured to run only in the development environment.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/phoenix

LANGUAGE: Elixir
CODE:
```
defp deps do  [
    # …
    {:tailwind, "~> 0.3", runtime: Mix.env() == :dev},
  ]end
```

--------------------------------

TITLE: Import Global CSS into SvelteKit Layout
DESCRIPTION: Creates a `+layout.svelte` file in the `src/routes` directory and imports the `app.css` stylesheet. This ensures that the global Tailwind CSS styles are applied across all pages in the SvelteKit application.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/sveltekit

LANGUAGE: Svelte
CODE:
```
<script>
  let { children } = $props();
  import "../app.css";
</script>

{@render children()}
```

--------------------------------

TITLE: Install Webpack Encore for asset building in Symfony
DESCRIPTION: Removes default Symfony UX bundles that might conflict or are not needed, then installs Webpack Encore along with `symfony/ux-turbo` and `symfony/stimulus-bundle`. Webpack Encore is essential for managing and compiling front-end assets like CSS and JavaScript.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/symfony

LANGUAGE: Shell
CODE:
```
composer remove symfony/ux-turbo symfony/asset-mapper symfony/stimulus-bundle
composer require symfony/webpack-encore-bundle symfony/ux-turbo symfony/stimulus-bundle
```

--------------------------------

TITLE: Install Tailwind CSS and PostCSS Dependencies
DESCRIPTION: Installs Tailwind CSS, `@tailwindcss/postcss`, and their peer dependencies (`postcss`, `postcss-loader`) required for integrating Tailwind CSS with PostCSS in a Rspack project.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/rspack/vue

LANGUAGE: Shell
CODE:
```
npm install tailwindcss @tailwindcss/postcss postcss postcss-loader
```

--------------------------------

TITLE: Import Tailwind CSS into Global Stylesheet
DESCRIPTION: Creates a new `app.css` file within the `src` directory and adds an `@import` rule to pull in Tailwind CSS directives, making its utility classes available globally.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/sveltekit

LANGUAGE: CSS
CODE:
```
@import "tailwindcss";
```

--------------------------------

TITLE: Update Tailwind CSS v4 Variant Stacking Order
DESCRIPTION: Explains the change in variant stacking order from right-to-left (v3) to left-to-right (v4) to align with CSS syntax. Provides an HTML example demonstrating how to reverse the order of order-sensitive stacked variants for migration.

SOURCE: https://tailwindcss.com/docs/upgrade-guide

LANGUAGE: HTML
CODE:
```
<ul class="py-4 first:*:pt-0 last:*:pb-0"><ul class="py-4 *:first:pt-0 *:last:pb-0">  <li>One</li>  <li>Two</li>  <li>Three</li></ul>
```

--------------------------------

TITLE: Install Tailwind CSS and Gatsby PostCSS plugin
DESCRIPTION: Installs the core Tailwind CSS package, its PostCSS plugin, the PostCSS processor itself, and the Gatsby plugin for PostCSS. These packages are crucial for integrating Tailwind CSS into a Gatsby build process.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/gatsby

LANGUAGE: bash
CODE:
```
npm install @tailwindcss/postcss tailwindcss postcss gatsby-plugin-postcss
```

--------------------------------

TITLE: Install Tailwind CSS and PostCSS dependencies via npm
DESCRIPTION: Installs the core `tailwindcss` package along with `@tailwindcss/postcss` and `postcss` as project dependencies using npm. The `--force` flag is used to resolve potential peer dependency conflicts during installation.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/angular

LANGUAGE: bash
CODE:
```
npm install tailwindcss @tailwindcss/postcss postcss --force
```

--------------------------------

TITLE: Create a new Angular project using Angular CLI
DESCRIPTION: Initializes a new Angular project with a specified style format (CSS in this case) and navigates into the newly created project directory. This is the foundational step before integrating Tailwind CSS.

SOURCE: https://tailwindcss.com/docs/installation/framework-guides/angular

LANGUAGE: bash
CODE:
```
ng new my-project --style css
cd my-project
```