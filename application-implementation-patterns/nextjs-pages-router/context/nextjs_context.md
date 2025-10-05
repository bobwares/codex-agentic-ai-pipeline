================
CODE SNIPPETS
================
TITLE: Quickstart Cypress Setup with create-next-app
DESCRIPTION: Use `create-next-app` with the `with-cypress` example to bootstrap a new Next.js project with Cypress already configured. This is the fastest way to get started.

SOURCE: https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/testing/cypress.mdx#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app@latest --example with-cypress with-cypress-app
```

--------------------------------

TITLE: Example `create-next-app` Interactive Prompts
DESCRIPTION: An example of the series of questions asked by the `create-next-app` CLI during the interactive setup process. It covers project naming, language choices, tooling, and directory structure.

SOURCE: https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/01-installation.mdx#_snippet_2

LANGUAGE: text
CODE:
```
What is your project named? my-app
Would you like to use TypeScript? No / Yes
Which linter would you like to use? ESLint / Biome / None
Would you like to use Tailwind CSS? No / Yes
Would you like your code inside a `src/` directory? No / Yes
Would you like to use App Router? (recommended) No / Yes
Would you like to use Turbopack? (recommended) No / Yes
Would you like to customize the import alias (`@/*` by default)? No / Yes
What import alias would you like configured? @/*
```

--------------------------------

TITLE: Create and Run a New Next.js App (Quick Start)
DESCRIPTION: Demonstrates the quickest way to scaffold a new Next.js application named `my-app` using the `create-next-app` CLI with default settings. The commands create the project, change into the new directory, and start the development server. Examples are provided for pnpm, npm, yarn, and bun.

SOURCE: https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/01-installation.mdx#_snippet_0

LANGUAGE: bash
CODE:
```
pnpm create next-app@latest my-app --yes
cd my-app
pnpm dev
```

LANGUAGE: bash
CODE:
```
npx create-next-app@latest my-app --yes
cd my-app
npm run dev
```

LANGUAGE: bash
CODE:
```
yarn create next-app@latest my-app --yes
cd my-app
yarn dev
```

LANGUAGE: bash
CODE:
```
bun create next-app@latest my-app --yes
cd my-app
bun dev
```

--------------------------------

TITLE: Bootstrap the Example Application with create-next-app
DESCRIPTION: Use npx, Yarn, or pnpm to initialize a new Next.js project from the `cms-tina` example template. This command sets up the complete project structure and necessary files to get started.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-tina/README.md#_snippet_0

LANGUAGE: npx
CODE:
```
npx create-next-app --example cms-tina cms-tina-app
```

LANGUAGE: yarn
CODE:
```
yarn create next-app --example cms-tina cms-tina-app
```

LANGUAGE: pnpm
CODE:
```
pnpm create next-app --example cms-tina cms-tina-app
```

--------------------------------

TITLE: Install Dependencies and Start the Development Server
DESCRIPTION: After setting up the project, run `npm install` to download all the required dependencies from the `package.json` file. Use `npm start` to launch the development server, which typically provides live-reloading and other development features.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-stencil/packages/test-component/readme.md#_snippet_1

LANGUAGE: bash
CODE:
```
npm install
npm start
```

--------------------------------

TITLE: Quickstart with create-next-app and Vitest
DESCRIPTION: Use `create-next-app` with the `with-vitest` example to quickly bootstrap a new Next.js project pre-configured with Vitest. This command creates a new directory named 'with-vitest-app' with the complete setup.

SOURCE: https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/testing/vitest.mdx#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app@latest --example with-vitest with-vitest-app
```

--------------------------------

TITLE: Install and Run the Next.js Project
DESCRIPTION: These shell commands first install the necessary project dependencies using npm, and then start the Next.js development server. The application will be available locally at localhost:3000.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-formspree/README.md#_snippet_0

LANGUAGE: shell
CODE:
```
# Install dependencies
npm install

# Run next locally at localhost:3000
npm run dev
```

--------------------------------

TITLE: Bootstrap the Example Project with create-next-app
DESCRIPTION: Use `create-next-app` with your preferred package manager (npm, Yarn, or pnpm) to quickly set up a new Next.js project based on the `with-userbase` example. This command clones the example repository and installs the necessary dependencies.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-userbase/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-userbase next-userbase-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-userbase next-userbase-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-userbase next-userbase-app
```

--------------------------------

TITLE: Bootstrap the Next.js api.video Example
DESCRIPTION: Use `create-next-app` with your preferred package manager (npm, Yarn, or pnpm) to initialize a new Next.js project based on the `with-apivideo` example. This command scaffolds the application structure and necessary files to get started.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-apivideo/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-apivideo with-apivideo-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-apivideo with-apivideo-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-apivideo with-apivideo-app
```

--------------------------------

TITLE: Install Dependencies and Run Next.js Dev Server
DESCRIPTION: These commands first install the project dependencies and then start the Next.js development server. The application will be accessible locally, typically at http://localhost:3000.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-sanity/README.md#_snippet_7

LANGUAGE: bash
CODE:
```
npm install && npm run dev
```

LANGUAGE: bash
CODE:
```
yarn install && yarn dev
```

LANGUAGE: bash
CODE:
```
pnpm install && pnpm dev
```

--------------------------------

TITLE: Create a Next.js App with the Turso Example
DESCRIPTION: Bootstrap a new Next.js application using the official `with-turso` example. These commands create a new project directory with all the necessary configuration to get started with Turso integration.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-turso/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-turso with-turso-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-turso with-turso-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-turso with-turso-app
```

--------------------------------

TITLE: Bootstrap Next.js Clerk Example with create-next-app
DESCRIPTION: Initialize a new Next.js project using the `with-clerk` example template. These commands demonstrate how to use `create-next-app` with npx, Yarn, and pnpm to get started.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-clerk/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-clerk with-clerk-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-clerk with-clerk-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-clerk with-clerk-app
```

--------------------------------

TITLE: Run the Next.js Development Server
DESCRIPTION: Install the project's dependencies and start the development server using either npm or Yarn. The blog will then be available on `http://localhost:3000`.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-cosmic/README.md#_snippet_2

LANGUAGE: bash
CODE:
```
npm install
npm run dev

# or

yarn install
yarn dev
```

--------------------------------

TITLE: Run the Next.js and Tigris App Locally
DESCRIPTION: This sequence of shell commands demonstrates how to set up and run the Next.js with Tigris example application on a local machine. It covers installing the Tigris CLI on macOS, cloning the repository, installing dependencies, and starting the development servers for both Tigris and Next.js.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-tigris/README.md#_snippet_0

LANGUAGE: shell
CODE:
```
# 1. Install Tigris CLI (macOS)
brew install tigrisdata/tigris/tigris-cli

# 2. Clone this repo on your computer
git clone https://github.com/tigrisdata/tigris-vercel-starter

# 3. Install dependencies
cd tigris-vercel-starter
npm install

# 4. Start Tigris local development environment
tigris dev start

# 5. Run the Next.js server
npm run dev
```

--------------------------------

TITLE: Install OpenTelemetry Dependencies
DESCRIPTION: Install the required packages to get started with OpenTelemetry in your Next.js application using npm. This includes `@vercel/otel` for quick setup, along with OpenTelemetry's SDK logs, API logs, and instrumentation packages.

SOURCE: https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/open-telemetry.mdx#_snippet_0

LANGUAGE: bash
CODE:
```
npm install @vercel/otel @opentelemetry/sdk-logs @opentelemetry/api-logs @opentelemetry/instrumentation
```

--------------------------------

TITLE: Initialize Environment File for Sanity Setup
DESCRIPTION: This command copies the example environment file `.env.local.example` to a new `.env.local` file. This is the first step in configuring the necessary environment variables for the Sanity.io integration in your Next.js project.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-sanity/README.md#_snippet_3

LANGUAGE: bash
CODE:
```
cp -i .env.local.example .env.local
```

--------------------------------

TITLE: Create a Next.js App with Playwright via Quickstart
DESCRIPTION: Bootstrap a new Next.js project that includes a pre-configured Playwright setup by using the official `with-playwright` example. This command creates a new directory named `with-playwright-app` with all necessary files and configurations.

SOURCE: https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/testing/playwright.mdx#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app@latest --example with-playwright with-playwright-app
```

--------------------------------

TITLE: Interactively Create a Next.js App with the CLI
DESCRIPTION: This command initiates the `create-next-app` interactive setup process. It prompts the user for project configuration details such as the project name, TypeScript usage, linter choice, Tailwind CSS integration, and other settings.

SOURCE: https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/01-installation.mdx#_snippet_1

LANGUAGE: bash
CODE:
```
npx create-next-app@latest
```

--------------------------------

TITLE: Bootstrap a Next.js App with Turbopack using npx, Yarn, or pnpm
DESCRIPTION: These commands use `create-next-app` to initialize a new Next.js project from the `with-turbopack` example. Choose the command corresponding to your preferred package manager (npm/npx, Yarn, or pnpm) to create the application.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-turbopack/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-turbopack with-turbopack-app

yarn create next-app --example with-turbopack with-turbopack-app

pnpm create next-app --example with-turbopack with-turbopack-app
```

--------------------------------

TITLE: Install Project Dependencies
DESCRIPTION: Installs project dependencies using npm, Yarn, or pnpm. This step is crucial for setting up the project after cloning or creating it. It does not take any input and prepares the project for further configuration and execution.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-knex/README.md#_snippet_1

LANGUAGE: bash
CODE:
```
npm install
```

LANGUAGE: bash
CODE:
```
yarn
```

LANGUAGE: bash
CODE:
```
pnpm install
```

--------------------------------

TITLE: Bootstrap the Example Application with create-next-app
DESCRIPTION: Use npx, Yarn, or pnpm to initialize a new project using the `cms-cosmic` example. This command scaffolds the application with all the necessary files and dependencies.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-cosmic/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example cms-cosmic cms-cosmic-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example cms-cosmic cms-cosmic-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example cms-cosmic cms-cosmic-app
```

--------------------------------

TITLE: Run the Next.js Development Server
DESCRIPTION: These commands start the Next.js development server. You can use the command corresponding to your preferred package manager (npm, Yarn, pnpm, or Bun). The server will typically run on http://localhost:3000.

SOURCE: https://github.com/vercel/next.js/blob/canary/packages/create-next-app/templates/app/ts/README-template.md#_snippet_0

LANGUAGE: bash
CODE:
```
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

--------------------------------

TITLE: Create Next.js App with EdgeDB Example
DESCRIPTION: Use create-next-app to bootstrap the project with the EdgeDB example. This command sets up the basic project structure and installs necessary dependencies.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-edgedb/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-edgedb with-edgedb-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-edgedb with-edgedb-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-edgedb with-edgedb-app
```

--------------------------------

TITLE: Bootstrap Next.js App with Firebase Example
DESCRIPTION: Initialize a new Next.js project using the `with-firebase` example. These commands demonstrate how to use `create-next-app` with npm, Yarn, and pnpm to get started quickly.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-firebase/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-firebase with-firebase-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-firebase with-firebase-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-firebase with-firebase-app
```

--------------------------------

TITLE: Bootstrap the Next.js Overmind Example
DESCRIPTION: Use `create-next-app` with npm, Yarn, or pnpm to initialize a new Next.js project from the `with-overmind` example. These commands will create a new directory named `with-overmind-app` containing the project setup.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-overmind/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-overmind with-overmind-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-overmind with-overmind-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-overmind with-overmind-app
```

--------------------------------

TITLE: Bootstrap the Example App with create-next-app
DESCRIPTION: Use `create-next-app` with npm, Yarn, or pnpm to initialize a new Next.js project based on the `with-react-md-typescript` example. Each command creates a new directory with the complete project setup.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-react-md-typescript/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-react-md-typescript with-react-md-typescript-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-react-md-typescript with-react-md-typescript-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-react-md-typescript with-react-md-typescript-app
```

--------------------------------

TITLE: Bootstrap the Next.js Algolia Example
DESCRIPTION: Use `create-next-app` to set up the example project locally. These commands bootstrap the application using npx, Yarn, pnpm, or Bun, creating a new directory with the project files.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-algolia-react-instantsearch/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-algolia-react-instantsearch with-algolia-react-instantsearch-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-algolia-react-instantsearch with-algolia-react-instantsearch-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-algolia-react-instantsearch with-algolia-react-instantsearch-app
```

LANGUAGE: bash
CODE:
```
bunx create-next-app --example with-algolia-react-instantsearch with-algolia-react-instantsearch-app
```

--------------------------------

TITLE: Bootstrap the Next.js Project with an Example
DESCRIPTION: Use the `create-next-app` command to initialize a new Next.js application based on the `blog-with-comment` example. This command sets up the project structure in a new directory named `blog-with-comment-app`.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/blog-with-comment/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example blog-with-comment blog-with-comment-app
```

--------------------------------

TITLE: Bootstrap a Next.js Blog Example with create-next-app
DESCRIPTION: Use the `create-next-app` command-line tool to initialize a new project based on the Next.js blog example. You can use npx, Yarn, or pnpm to execute the command, which will create a new directory named 'my-blog' with the project files.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/blog/README.md#_snippet_0

LANGUAGE: Bash
CODE:
```
npx create-next-app --example blog my-blog
```

LANGUAGE: Bash
CODE:
```
yarn create next-app --example blog my-blog
```

LANGUAGE: Bash
CODE:
```
pnpm create next-app --example blog my-blog
```

--------------------------------

TITLE: Manually Install Next.js Dependencies
DESCRIPTION: Shows the commands to manually install the necessary core packages (`next`, `react`, `react-dom`) for a Next.js project. This is an alternative to using the `create-next-app` CLI. Examples are provided for pnpm, npm, yarn, and bun.

SOURCE: https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/01-installation.mdx#_snippet_3

LANGUAGE: bash
CODE:
```
pnpm i next@latest react@latest react-dom@latest
```

LANGUAGE: bash
CODE:
```
npm i next@latest react@latest react-dom@latest
```

LANGUAGE: bash
CODE:
```
yarn add next@latest react@latest react-dom@latest
```

LANGUAGE: bash
CODE:
```
bun add next@latest react@latest react-dom@latest
```

--------------------------------

TITLE: Bootstrap the Next.js SEO Example App
DESCRIPTION: Use the `create-next-app` command with your preferred package manager to set up the example project. These commands bootstrap a new Next.js application in a folder named `next-seo-app`, pre-configured with the `next-seo` library.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-next-seo/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-next-seo next-seo-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-next-seo next-seo-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-next-seo next-seo-app
```

--------------------------------

TITLE: Bootstrap the Example App with create-next-app
DESCRIPTION: Initialize a new Next.js project based on the `with-graphql-gateway` example using your preferred package manager. These commands will create a new directory with the example's code and dependencies.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-graphql-gateway/README.md#_snippet_1

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-graphql-gateway with-graphql-gateway-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-graphql-gateway with-graphql-gateway-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-graphql-gateway with-graphql-gateway-app
```

--------------------------------

TITLE: Create Next.js app with MongoDB example
DESCRIPTION: Uses create-next-app to bootstrap a Next.js project with the MongoDB example.  This command initializes a new project with necessary dependencies and configurations for MongoDB integration. Requires npm, Yarn, or pnpm to be installed.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-mongodb/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-mongodb with-mongodb-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-mongodb with-mongodb-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-mongodb with-mongodb-app
```

--------------------------------

TITLE: Bootstrap the Next.js `graphql-react` Example
DESCRIPTION: Use `create-next-app` with your preferred package manager (npm, Yarn, or pnpm) to set up a new Next.js project pre-configured with the `graphql-react` example. These commands will create a new directory named `with-graphql-react-app` containing the example project.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-graphql-react/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-graphql-react with-graphql-react-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-graphql-react with-graphql-react-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-graphql-react with-graphql-react-app
```

--------------------------------

TITLE: Bootstrap the Example App with create-next-app
DESCRIPTION: Use `create-next-app` with your preferred package manager (npx, Yarn, or pnpm) to initialize a new project from the `cms-builder-io` example. This command sets up the basic file structure and dependencies for the blog application.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-builder-io/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example cms-builder-io cms-builder-io-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example cms-builder-io cms-builder-io-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example cms-builder-io cms-builder-io-app
```

--------------------------------

TITLE: Run the Next.js Development Server
DESCRIPTION: Install project dependencies and start the local development server using either npm or Yarn. Once running, the blog will be available for preview at http://localhost:3000.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-builder-io/README.md#_snippet_4

LANGUAGE: bash
CODE:
```
npm install
npm run dev
```

LANGUAGE: bash
CODE:
```
yarn install
yarn dev
```

--------------------------------

TITLE: Bootstrap the Next.js Blog Starter App
DESCRIPTION: Use `create-next-app` with your preferred package manager (npm, Yarn, or pnpm) to bootstrap the blog starter example. This command will create a new directory named `blog-starter-app` with the project files.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/blog-starter/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example blog-starter blog-starter-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example blog-starter blog-starter-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example blog-starter blog-starter-app
```

--------------------------------

TITLE: Bootstrap the Example App with create-next-app
DESCRIPTION: Use `create-next-app` with npx, Yarn, or pnpm to initialize a new Next.js project from the `with-react-toolbox` example. This command creates a new directory with the example code and all necessary dependencies.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-react-toolbox/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-react-toolbox with-react-toolbox-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-react-toolbox with-react-toolbox-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-react-toolbox with-react-toolbox-app
```

--------------------------------

TITLE: Bootstrap the Example App with create-next-app
DESCRIPTION: Use `create-next-app` with your preferred package manager (npm, Yarn, or pnpm) to set up a new project based on the `cms-datocms` example. This command downloads the template and initializes a new Next.js application in the `cms-datocms-app` directory.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-datocms/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example cms-datocms cms-datocms-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example cms-datocms cms-datocms-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example cms-datocms cms-datocms-app
```

--------------------------------

TITLE: Start the Application Server for Benchmarking
DESCRIPTION: Before running any benchmark tests, start the Next.js application server using this command. This prepares the application to handle requests from the benchmarking tool, which requires `ab` (Apache Bench) to be installed.

SOURCE: https://github.com/vercel/next.js/blob/canary/bench/rendering/readme.md#_snippet_0

LANGUAGE: bash
CODE:
```
npm run start
```

--------------------------------

TITLE: Bootstrap the Apollo Example with create-next-app
DESCRIPTION: Create a new Next.js application pre-configured with Apollo Server and Client using `create-next-app`. These commands demonstrate how to initialize the project using npx, Yarn, or pnpm, by referencing the `api-routes-apollo-server-and-client` example.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/api-routes-apollo-server-and-client/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example api-routes-apollo-server-and-client api-routes-apollo-server-and-client-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example api-routes-apollo-server-and-client api-routes-apollo-server-and-client-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example api-routes-apollo-server-and-client api-routes-apollo-server-and-client-app
```

--------------------------------

TITLE: Bootstrap the Temporal + Next.js Example
DESCRIPTION: Use `create-next-app` with your preferred package manager (npm, Yarn, or pnpm) to bootstrap the example project. This command clones the `with-temporal` example and sets up a new Next.js application directory.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-temporal/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-temporal next-temporal-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-temporal next-temporal-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-temporal next-temporal-app
```

--------------------------------

TITLE: Bootstrap the Next.js Ghost CMS Example
DESCRIPTION: Use `create-next-app` with npx, Yarn, or pnpm to initialize a new project from the `cms-ghost` example template. This command sets up the basic file structure and dependencies for the blog application.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-ghost/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example cms-ghost cms-ghost-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example cms-ghost cms-ghost-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example cms-ghost cms-ghost-app
```

--------------------------------

TITLE: Bootstrap a Next.js App with the Umbraco Example
DESCRIPTION: Use `create-next-app` to initialize a new Next.js project based on the `cms-umbraco` example. These commands demonstrate how to achieve this using npx, Yarn, or pnpm.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-umbraco/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example cms-umbraco umbraco-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example cms-umbraco umbraco-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example cms-umbraco umbraco-app
```

--------------------------------

TITLE: Bootstrap the Next.js Cloudinary Example App
DESCRIPTION: Use `create-next-app` to set up the example project. These commands bootstrap the application from the `with-cloudinary` example template, creating a new directory named `with-cloudinary-app`. The commands are provided for npx, Yarn, and pnpm package managers.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-cloudinary/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-cloudinary with-cloudinary-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-cloudinary with-cloudinary-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-cloudinary with-cloudinary-app
```

--------------------------------

TITLE: Create Next.js App with MQTT.js Example
DESCRIPTION: Uses create-next-app to bootstrap a new Next.js project with the with-mqtt-js example. This command sets up the basic project structure and dependencies for MQTT integration.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-mqtt-js/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-mqtt-js with-mqtt-js-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-mqtt-js with-mqtt-js-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-mqtt-js with-mqtt-js-app
```

--------------------------------

TITLE: Install dependencies and run Next.js dev server
DESCRIPTION: Installs the project dependencies and starts the Next.js development server. This allows you to test and debug your application locally.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-mongodb-mongoose/README.md#_snippet_1

LANGUAGE: bash
CODE:
```
npm install
npm run dev
```

LANGUAGE: bash
CODE:
```
yarn install
yarn dev
```

LANGUAGE: bash
CODE:
```
pnpm install
pnpm dev
```

--------------------------------

TITLE: Bootstrap the Example App with create-next-app
DESCRIPTION: These commands bootstrap the `react-remove-properties` example application using `create-next-app`. You can use your preferred package manager (npm, Yarn, or pnpm) to execute the setup.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/react-remove-properties/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example react-remove-properties react-remove-properties-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example react-remove-properties react-remove-properties-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example react-remove-properties react-remove-properties-app
```

--------------------------------

TITLE: Create Next.js App with Ionic Example (pnpm)
DESCRIPTION: This command uses pnpm to create a new Next.js application with the Ionic example. It requires pnpm to be installed. The resulting application will be named 'with-ionic-app'.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-ionic/README.md#_snippet_2

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-ionic with-ionic-app
```

--------------------------------

TITLE: Run the Development Server
DESCRIPTION: Start the development server for both the Next.js application and the Inngest dev server. The Next.js app will be accessible at http://localhost:3000, while the Inngest dev server will be at http://localhost:8288.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/inngest/README.md#_snippet_1

LANGUAGE: bash
CODE:
```
npm run dev
```

LANGUAGE: bash
CODE:
```
yarn dev
```

LANGUAGE: bash
CODE:
```
pnpm dev
```

LANGUAGE: bash
CODE:
```
bun dev
```

--------------------------------

TITLE: Create Next.js App with Ionic Example (npm)
DESCRIPTION: This command uses npm to create a new Next.js application with the Ionic example. It requires npm to be installed. The resulting application will be named 'with-ionic-app'.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-ionic/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-ionic with-ionic-app
```

--------------------------------

TITLE: Bootstrap the Next.js Agility CMS Example
DESCRIPTION: Initialize a new Next.js project using the `cms-agilitycms` example template. These commands use npx, Yarn, or pnpm to create a new application directory with the necessary boilerplate.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-agilitycms/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example cms-agilitycms cms-agilitycms-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example cms-agilitycms cms-agilitycms-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example cms-agilitycms cms-agilitycms-app
```

--------------------------------

TITLE: Run the Storybook Development Server
DESCRIPTION: Execute these commands to start the Storybook development server. This allows you to view and interact with your UI components in an isolated environment provided by Storybook.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-storybook/README.md#_snippet_1

LANGUAGE: bash
CODE:
```
npm run storybook
```

LANGUAGE: bash
CODE:
```
yarn storybook
```

LANGUAGE: bash
CODE:
```
pnpm storybook
```

--------------------------------

TITLE: Create a Next.js App with npx, Yarn, or pnpm
DESCRIPTION: Bootstrap a new Next.js application using the 'hello-world' example. These commands utilize different package managers (npm via npx, Yarn, and pnpm) to initialize a new project directory named 'hello-world-app'.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/hello-world/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example hello-world hello-world-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example hello-world hello-world-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example hello-world hello-world-app
```

--------------------------------

TITLE: Setup Ably API Key Environment Variables
DESCRIPTION: Example of how to create a `.env` file in the root of the demo repository and set the `ABLY_API_KEY` and `API_ROOT` environment variables.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-ably/README.md#_snippet_4

LANGUAGE: bash
CODE:
```
ABLY_API_KEY=your-ably-api-key:goes-here
API_ROOT=http://localhost:3000
```

--------------------------------

TITLE: Create Next.js App with Ionic Example (Yarn)
DESCRIPTION: This command uses Yarn to create a new Next.js application with the Ionic example. It requires Yarn to be installed. The resulting application will be named 'with-ionic-app'.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-ionic/README.md#_snippet_1

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-ionic with-ionic-app
```

--------------------------------

TITLE: Install Project via GitHub and NPM/Yarn
DESCRIPTION: Clone the starter project repository from GitHub, navigate into the directory, and install the necessary dependencies using either npm or yarn. This is the first step for a manual setup.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-buttercms/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
git clone https://github.com/ButterCMS/nextjs-starter-buttercms.git
cd nextjs-starter-buttercms
npm install # or yarn install
```

--------------------------------

TITLE: Bootstrap the Example Project
DESCRIPTION: Initialize a new Next.js application using the `cms-dotcms` example template. These commands use `create-next-app` with npx, Yarn, and pnpm to set up the project structure and dependencies.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-dotcms/README.md#_snippet_1

LANGUAGE: bash
CODE:
```
npx create-next-app --example cms-dotcms cms-dotcms-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example cms-dotcms cms-dotcms-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example cms-dotcms cms-dotcms-app
```

--------------------------------

TITLE: Create Next.js App with MySQL Example
DESCRIPTION: Uses `create-next-app` to bootstrap a new Next.js project with the `with-mysql` example. This sets up the basic project structure and dependencies.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-mysql/README.md#_snippet_2

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-mysql nextjs-mysql
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-mysql nextjs-mysql
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-mysql nextjs-mysql
```

--------------------------------

TITLE: Build and Run the Production App
DESCRIPTION: After setting up the project, use these commands to build the application for production and start the server. Equivalent commands are shown for npm, Yarn, and pnpm.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-sass/README.md#_snippet_1

LANGUAGE: bash
CODE:
```
npm run build
npm run start
# or
yarn build
yarn start
# or
pnpm build
pnpm start
```

--------------------------------

TITLE: Bootstrap the Example Project with create-next-app
DESCRIPTION: Use `create-next-app` with your preferred package manager (npx, Yarn, or pnpm) to bootstrap the `cms-makeswift` example project into a new directory.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-makeswift/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example cms-makeswift cms-makeswift-app

yarn create next-app --example cms-makeswift cms-makeswift-app

pnpm create next-app --example cms-makeswift cms-makeswift-app
```

--------------------------------

TITLE: Start the Development Server
DESCRIPTION: Run the project in development mode to preview it locally. The application will be accessible in your browser, typically at localhost:3000. Use the command for your chosen package manager.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-relay-modern/README.md#_snippet_3

LANGUAGE: bash
CODE:
```
npm run dev
# or
yarn dev
# or
pnpm dev
```

--------------------------------

TITLE: Create Next.js app with MobX example using npm
DESCRIPTION: Uses npm to bootstrap a new Next.js application using the with-mobx example. This command initializes a new project with the necessary dependencies and configurations for MobX.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-mobx/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-mobx with-mobx-app
```

--------------------------------

TITLE: Bootstrap the Next.js Prefetching Example
DESCRIPTION: Use `create-next-app` with your preferred package manager (npx, Yarn, or pnpm) to initialize a new project from the 'with-prefetching' example. This command sets up a sample Next.js application demonstrating different page prefetching strategies.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-prefetching/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-prefetching with-prefetching-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-prefetching with-prefetching-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-prefetching with-prefetching-app
```

--------------------------------

TITLE: Bootstrap the WebAssembly Example Project
DESCRIPTION: Use `create-next-app` with your preferred package manager (npm, Yarn, or pnpm) to initialize a new Next.js project pre-configured with the WebAssembly example.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-webassembly/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-webassembly with-webassembly-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-webassembly with-webassembly-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-webassembly with-webassembly-app
```

--------------------------------

TITLE: Bootstrap the Next.js Neo4j Example App
DESCRIPTION: Use npx, Yarn, or pnpm to create a new Next.js application based on the 'with-neo4j' example. This command will set up a new project directory with the example code.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-neo4j/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-neo4j with-neo4j-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-neo4j with-neo4j-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-neo4j with-neo4j-app
```

--------------------------------

TITLE: Bootstrap the Next.js Sitefinity App with create-next-app
DESCRIPTION: Use `create-next-app` to initialize a new project based on the `cms-sitefinity` example. This command can be run with npx, Yarn, or pnpm and will scaffold a new application in the `cms-sitefinity-app` directory.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-sitefinity/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example cms-sitefinity cms-sitefinity-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example cms-sitefinity cms-sitefinity-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example cms-sitefinity cms-sitefinity-app
```

--------------------------------

TITLE: Bootstrap the Example Application
DESCRIPTION: Use `create-next-app` with your preferred package manager (npm, Yarn, or pnpm) to initialize a new Next.js project based on the `cms-umbraco-heartcore` example.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-umbraco-heartcore/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example cms-umbraco-heartcore cms-umbraco-heartcore-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example cms-umbraco-heartcore cms-umbraco-heartcore-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example cms-umbraco-heartcore cms-umbraco-heartcore-app
```

--------------------------------

TITLE: Quickstart a Next.js App with Jest
DESCRIPTION: Use `create-next-app` with the `with-jest` example to quickly scaffold a new Next.js project that comes pre-configured with Jest for testing.

SOURCE: https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/testing/jest.mdx#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app@latest --example with-jest with-jest-app
```

--------------------------------

TITLE: Bootstrap Next.js Redis Example with create-next-app
DESCRIPTION: Use npx, Yarn, or pnpm to initialize a new Next.js application from the `cache-handler-redis` example template. These commands set up the project structure and initial dependencies required to run the example.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cache-handler-redis/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example cache-handler-redis cache-handler-redis-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example cache-handler-redis cache-handler-redis-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example cache-handler-redis cache-handler-redis-app
```

--------------------------------

TITLE: Use Regex in Next.js Middleware Matcher to Exclude Paths
DESCRIPTION: The `matcher` config in Next.js Middleware supports full regular expressions. This example demonstrates using a negative lookahead `((?!...))` to apply middleware to all paths except for those starting with `/api`, `/_next/static`, or `/favicon.ico`.

SOURCE: https://github.com/vercel/next.js/blob/canary/errors/middleware-upgrade-guide.mdx#_snippet_1

LANGUAGE: typescript
CODE:
```
export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - api (API routes)
     * - _next/static (static files)
     * - favicon.ico (favicon file)
     */
    '/((?!api|_next/static|favicon.ico).*)',
  ],
}
```

--------------------------------

TITLE: Bootstrap the Apollo Auth Example with create-next-app
DESCRIPTION: Use npx, Yarn, or pnpm to initialize a new Next.js project from the `api-routes-apollo-server-and-client-auth` example. These commands will create a new directory with the example project ready to run.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/api-routes-apollo-server-and-client-auth/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example api-routes-apollo-server-and-client-auth api-routes-apollo-server-and-client-auth-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example api-routes-apollo-server-and-client-auth api-routes-apollo-server-and-client-auth-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example api-routes-apollo-server-and-client-auth api-routes-apollo-server-and-client-auth-app
```

--------------------------------

TITLE: Bootstrap the Next.js Nhost Example App
DESCRIPTION: Use `create-next-app` to initialize a new Next.js project based on the `with-nhost-auth-realtime-graphql` example. Choose the command that corresponds to your preferred package manager: npm (via npx), Yarn, or pnpm.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-nhost-auth-realtime-graphql/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-nhost-auth-realtime-graphql nhost-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-nhost-auth-realtime-graphql nhost-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-nhost-auth-realtime-graphql nhost-app
```

--------------------------------

TITLE: Configure Jest to Use a Setup File
DESCRIPTION: Configure Jest to run a setup file before each test by adding the `setupFilesAfterEnv` option to your Jest configuration. This is used to import custom matchers or other global test setup. Examples are provided for both TypeScript (`jest.config.ts`) and JavaScript (`jest.config.js`).

SOURCE: https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/testing/jest.mdx#_snippet_8

LANGUAGE: typescript
CODE:
```
setupFilesAfterEnv: ['<rootDir>/jest.setup.ts']
```

LANGUAGE: javascript
CODE:
```
setupFilesAfterEnv: ['<rootDir>/jest.setup.js']
```

--------------------------------

TITLE: Install Partytown Dependencies
DESCRIPTION: After enabling the `nextScriptWorkers` flag, run your development server. Next.js will detect the configuration and provide instructions to install the required Partytown package to complete the setup.

SOURCE: https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/scripts.mdx#_snippet_4

LANGUAGE: bash
CODE:
```
npm run dev
```

--------------------------------

TITLE: Bootstrap the Next.js 'with-polyfills' Example
DESCRIPTION: Use `create-next-app` with your preferred package manager (npm, Yarn, or pnpm) to set up a new Next.js project based on the 'with-polyfills' example. This provides a starting point for applications requiring custom polyfills.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-polyfills/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-polyfills with-polyfills-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-polyfills with-polyfills-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-polyfills with-polyfills-app
```

--------------------------------

TITLE: Bootstrap the Next.js with Rematch Example App
DESCRIPTION: Use `create-next-app` with your preferred package manager (npm, Yarn, or pnpm) to set up a new Next.js project that is pre-configured with the Rematch example. This command will create a new directory named 'with-rematch-app' containing the example project.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-rematch/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-rematch with-rematch-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-rematch with-rematch-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-rematch with-rematch-app
```

--------------------------------

TITLE: Bootstrap the Next.js Realm-Web Example App
DESCRIPTION: Use npx, Yarn, or pnpm to create a new Next.js project based on the 'with-realm-web' example. This command initializes a new application directory with the necessary files and dependencies.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-realm-web/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-realm-web with-realm-web-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-realm-web with-realm-web-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-realm-web with-realm-web-app
```

--------------------------------

TITLE: Bootstrap the Example with create-next-app
DESCRIPTION: These commands use `create-next-app` to set up the 'with-framer-motion' example project in a new directory. You can use your preferred package manager: npm, Yarn, or pnpm.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-framer-motion/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
npx create-next-app --example with-framer-motion with-framer-motion-app
```

LANGUAGE: bash
CODE:
```
yarn create next-app --example with-framer-motion with-framer-motion-app
```

LANGUAGE: bash
CODE:
```
pnpm create next-app --example with-framer-motion with-framer-motion-app
```

--------------------------------

TITLE: Install Project Dependencies
DESCRIPTION: Install the required project dependencies listed in the `package.json` file. Use either `npm install` or `yarn install` depending on your preferred package manager.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-prepr/README.md#_snippet_2

LANGUAGE: bash
CODE:
```
npm install
```

LANGUAGE: bash
CODE:
```
yarn install
```

--------------------------------

TITLE: Next.js Docs File Structure: Ordered Learning Path
DESCRIPTION: This `txt` example demonstrates file-system routing for the Next.js routing section, where files are prefixed with two-digit numbers (e.g., `01-`) to explicitly sort them in a pedagogical order, guiding developers through concepts sequentially.

SOURCE: https://github.com/vercel/next.js/blob/canary/docs/04-community/01-contribution-guide.mdx#_snippet_2

LANGUAGE: txt
CODE:
```
01-routing
├── 01-defining-routes.mdx
├── 02-pages.mdx
├── 03-layouts-and-templates.mdx
└── ...
```

--------------------------------

TITLE: Run a Next.js Project with Yarn
DESCRIPTION: This sequence of shell commands first installs the project's dependencies using `yarn install` and then starts the Next.js development server on `localhost:3000` with `yarn dev`.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/cms-buttercms/README.md#_snippet_3

LANGUAGE: shell
CODE:
```
yarn install
yarn dev
```

--------------------------------

TITLE: Run the 'blog' Zone Application
DESCRIPTION: In a new terminal, start the 'blog' zone application by navigating into its directory, installing dependencies, and running the development server. This app serves the /blog/* paths and will be available at http://localhost:4000/blog.

SOURCE: https://github.com/vercel/next.js/blob/canary/examples/with-zones/README.md#_snippet_2

LANGUAGE: bash
CODE:
```
cd blog
npm install && npm run dev
```

LANGUAGE: bash
CODE:
```
cd blog
yarn && yarn dev
```

LANGUAGE: bash
CODE:
```
cd blog
pnpm install && pnpm dev
```