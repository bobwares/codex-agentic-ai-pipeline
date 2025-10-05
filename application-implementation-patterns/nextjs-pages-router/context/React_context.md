================
CODE SNIPPETS
================
TITLE: React Application Setup and Styling for Strict Mode Example
DESCRIPTION: This snippet provides the foundational setup for a React application, including the main entry point, a root App component managing initial data with `useState`, and basic CSS styling. This boilerplate demonstrates how a typical React application is structured to run the `StoryTray` component examples.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/reference/react/StrictMode.md#_snippet_3

LANGUAGE: javascript
CODE:
```
import { createRoot } from 'react-dom/client';
import './styles.css';

import App from './App';

const root = createRoot(document.getElementById("root"));
root.render(<App />);
```

LANGUAGE: javascript
CODE:
```
import { useState } from 'react';
import StoryTray from './StoryTray.js';

let initialStories = [
  {id: 0, label: "Ankit's Story" },
  {id: 1, label: "Taylor's Story" },
];

export default function App() {
  let [stories, setStories] = useState(initialStories)
  return (
    <div
      style={{
        width: '100%',
        height: '100%',
        textAlign: 'center',
      }}
    >
      <StoryTray stories={stories} />
    </div>
  );
}
```

LANGUAGE: css
CODE:
```
ul {
  margin: 0;
  list-style-type: none;
  height: 100%;
  display: flex;
  flex-wrap: wrap;
  padding: 10px;
}

li {
  border: 1px solid #aaa;
  border-radius: 6px;
  float: left;
  margin: 5px;
  padding: 5px;
  width: 70px;
  height: 100px;
}
```

--------------------------------

TITLE: Full example of nested React components
DESCRIPTION: This complete example demonstrates how a `MyButton` component is defined and then nested within a `MyApp` component, showcasing basic component composition.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/learn/index.md#_snippet_2

LANGUAGE: js
CODE:
```
function MyButton() {
  return (
    <button>
      I'm a button
    </button>
  );
}

export default function MyApp() {
  return (
    <div>
      <h1>Welcome to my app</h1>
      <MyButton />
    </div>
  );
}
```

--------------------------------

TITLE: Create a basic React component function
DESCRIPTION: React components are JavaScript functions that return markup. This example defines a simple button component.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/learn/index.md#_snippet_0

LANGUAGE: js
CODE:
```
function MyButton() {
  return (
    <button>I'm a button</button>
  );
}
```

--------------------------------

TITLE: Complete example of lifting state up in React
DESCRIPTION: This comprehensive example combines all the steps of lifting state up: the `MyApp` component manages the shared `count` state and `handleClick` function, passing them down as props. The `MyButton` component receives and uses these props, demonstrating how both buttons update together when clicked. Basic CSS is included for styling.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/learn/index.md#_snippet_23

LANGUAGE: javascript
CODE:
```
import { useState } from 'react';

export default function MyApp() {
  const [count, setCount] = useState(0);

  function handleClick() {
    setCount(count + 1);
  }

  return (
    <div>
      <h1>Counters that update together</h1>
      <MyButton count={count} onClick={handleClick} />
      <MyButton count={count} onClick={handleClick} />
    </div>
  );
}

function MyButton({ count, onClick }) {
  return (
    <button onClick={onClick}>
      Clicked {count} times
    </button>
  );
}
```

LANGUAGE: css
CODE:
```
button {
  display: block;
  margin-bottom: 5px;
}
```

--------------------------------

TITLE: Install React 19 and React DOM packages
DESCRIPTION: Commands to install the latest React 19 and React DOM packages with exact version matching using either npm or Yarn.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/blog/2024/04/25/react-19-upgrade-guide.md#_snippet_0

LANGUAGE: bash
CODE:
```
npm install --save-exact react@^19.0.0 react-dom@^19.0.0
```

LANGUAGE: bash
CODE:
```
yarn add --exact react@^19.0.0 react-dom@^19.0.0
```

--------------------------------

TITLE: Configure React Compiler in Babel
DESCRIPTION: Example `babel.config.js` configuration to include `babel-plugin-react-compiler` in your Babel plugins array. It's crucial that this plugin runs first in the pipeline for proper analysis, as it needs the original source information.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/learn/react-compiler/installation.md#_snippet_1

LANGUAGE: JavaScript
CODE:
```
module.exports = {
  plugins: [
    'babel-plugin-react-compiler', // must run first!
    // ... other plugins
  ],
  // ... other config
};
```

--------------------------------

TITLE: Migrate `react-test-renderer/shallow` to `react-shallow-renderer`
DESCRIPTION: Details the migration path for `react-test-renderer/shallow`, which is removed in React 19. Users should directly install and import `react-shallow-renderer` instead. An `npm install` command and a `diff` example are provided for a clear transition.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/blog/2024/04/25/react-19-upgrade-guide.md#_snippet_11

LANGUAGE: Bash
CODE:
```
npm install react-shallow-renderer --save-dev
```

LANGUAGE: Diff
CODE:
```
- import ShallowRenderer from 'react-test-renderer/shallow';
+ import ShallowRenderer from 'react-shallow-renderer';
```

--------------------------------

TITLE: Install ESLint Plugin for React Hooks with Compiler Support
DESCRIPTION: This command installs the `eslint-plugin-react-hooks` package as a development dependency, which includes the React Compiler's ESLint rule. This rule helps identify code that cannot be optimized by the compiler, guiding developers to improve component optimizability.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/learn/react-compiler/installation.md#_snippet_5

LANGUAGE: Shell
CODE:
```
npm install -D eslint-plugin-react-hooks@rc
```

--------------------------------

TITLE: Configure React Compiler with React Router and Vite
DESCRIPTION: Example `vite.config.js` for integrating React Compiler with React Router, specifically using `vite-plugin-babel`. This setup demonstrates how to apply the compiler plugin with a filter and optionally include TypeScript presets for projects using TypeScript.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/learn/react-compiler/installation.md#_snippet_4

LANGUAGE: npm
CODE:
```
npm install vite-plugin-babel
```

LANGUAGE: JavaScript
CODE:
```
// vite.config.js
import { defineConfig } from "vite";
import babel from "vite-plugin-babel";
import { reactRouter } from "@react-router/dev/vite";

const ReactCompilerConfig = { /* ... */ };

export default defineConfig({
  plugins: [
    reactRouter(),
    babel({
      filter: /\.[jt]sx?$/,
      babelConfig: {
        presets: ["@babel/preset-typescript"], // if you use TypeScript
        plugins: [
          ["babel-plugin-react-compiler", ReactCompilerConfig],
        ],
      },
    }),
  ],
});
```

--------------------------------

TITLE: Example of React Compiler's Automatic Memoization Logic in Build Output
DESCRIPTION: This JavaScript code snippet demonstrates the automatic memoization logic added by the React Compiler to the build output. It shows how the compiler transforms a component to include runtime checks for memoization, verifying that the compiler is active and optimizing components without manual `useMemo`.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/learn/react-compiler/installation.md#_snippet_6

LANGUAGE: JavaScript
CODE:
```
import { c as _c } from "react/compiler-runtime";
export default function MyApp() {
  const $ = _c(1);
  let t0;
  if ($[0] === Symbol.for("react.memo_cache_sentinel")) {
    t0 = <div>Hello World</div>;
    $[0] = t0;
  } else {
    t0 = $[0];
  }
  return t0;
}
```

--------------------------------

TITLE: Complete Example: Streaming Data with React Suspense and `use` API
DESCRIPTION: This comprehensive example demonstrates the full flow of streaming data from a simulated server to a client using React. It includes a `Message` component that uses the `use` API, a `MessageContainer` with `Suspense` for loading states, and an `App` component that triggers the data download and passes the Promise. This setup provides a non-blocking user experience while data is being fetched.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/reference/react/use.md#_snippet_8

LANGUAGE: js
CODE:
```
"use client";

import { use, Suspense } from "react";

function Message({ messagePromise }) {
  const messageContent = use(messagePromise);
  return <p>Here is the message: {messageContent}</p>;
}

export function MessageContainer({ messagePromise }) {
  return (
    <Suspense fallback={<p>⌛Downloading message...</p>}>
      <Message messagePromise={messagePromise} />
    </Suspense>
  );
}
```

LANGUAGE: js
CODE:
```
import { useState } from "react";
import { MessageContainer } from "./message.js";

function fetchMessage() {
  return new Promise((resolve) => setTimeout(resolve, 1000, "⚛️"));
}

export default function App() {
  const [messagePromise, setMessagePromise] = useState(null);
  const [show, setShow] = useState(false);
  function download() {
    setMessagePromise(fetchMessage());
    setShow(true);
  }

  if (show) {
    return <MessageContainer messagePromise={messagePromise} />;
  } else {
    return <button onClick={download}>Download message</button>;
  }
}
```

LANGUAGE: js
CODE:
```
import React, { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import './styles.css';

// TODO: update this example to use
// the Codesandbox Server Component
// demo environment once it is created
import App from './App';

const root = createRoot(document.getElementById('root'));
root.render(
  <StrictMode>
    <App />
  </StrictMode>
);
```

--------------------------------

TITLE: Display a Greeting in React Sandbox
DESCRIPTION: This snippet demonstrates a basic React component (`Greeting`) and its usage within an `App` component, suitable for quick experimentation in an online sandbox. It shows how to render a simple 'Hello, world' message without requiring any local installation.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/learn/installation.md#_snippet_0

LANGUAGE: JavaScript
CODE:
```
function Greeting({ name }) {
  return <h1>Hello, {name}</h1>;
}

export default function App() {
  return <Greeting name="world" />
}
```

--------------------------------

TITLE: Install React 19 TypeScript type definitions
DESCRIPTION: Commands to install the TypeScript type definitions for React 19 and React DOM with exact version matching using either npm or Yarn.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/blog/2024/04/25/react-19-upgrade-guide.md#_snippet_1

LANGUAGE: bash
CODE:
```
npm install --save-exact @types/react@^19.0.0 @types/react-dom@^19.0.0
```

LANGUAGE: bash
CODE:
```
yarn add --exact @types/react@^19.0.0 @types/react-dom@^19.0.0
```

--------------------------------

TITLE: Build a React 'Get Inspired' App with Component Composition
DESCRIPTION: This comprehensive example demonstrates a React application that generates inspirational quotes, showcasing component composition, state management, and styling. It includes the main App component, reusable FancyText, InspirationGenerator, and Copyright components, a data module for quotes, and associated CSS styles to illustrate how a render tree is formed.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/learn/understanding-your-ui-as-a-tree.md#_snippet_0

LANGUAGE: JavaScript
CODE:
```
import FancyText from './FancyText';
import InspirationGenerator from './InspirationGenerator';
import Copyright from './Copyright';

export default function App() {
  return (
    <>
      <FancyText title text="Get Inspired App" />
      <InspirationGenerator>
        <Copyright year={2004} />
      </InspirationGenerator>
    </>
  );
}
```

LANGUAGE: JavaScript
CODE:
```
export default function FancyText({title, text}) {
  return title
    ? <h1 className='fancy title'>{text}</h1>
    : <h3 className='fancy cursive'>{text}</h3>
}
```

LANGUAGE: JavaScript
CODE:
```
import * as React from 'react';
import quotes from './quotes';
import FancyText from './FancyText';

export default function InspirationGenerator({children}) {
  const [index, setIndex] = React.useState(0);
  const quote = quotes[index];
  const next = () => setIndex((index + 1) % quotes.length);

  return (
    <>
      <p>Your inspirational quote is:</p>
      <FancyText text={quote} />
      <button onClick={next}>Inspire me again</button>
      {children}
    </>
  );
}
```

LANGUAGE: JavaScript
CODE:
```
export default function Copyright({year}) {
  return <p className='small'>©️ {year}</p>;
}
```

LANGUAGE: JavaScript
CODE:
```
export default [
  "Don’t let yesterday take up too much of today.” — Will Rogers",
  "Ambition is putting a ladder against the sky.",
  "A joy that's shared is a joy made double.",
  ];
```

LANGUAGE: CSS
CODE:
```
.fancy {
  font-family: 'Georgia';
}
.title {
  color: #007AA3;
  text-decoration: underline;
}
.cursive {
  font-style: italic;
}
.small {
  font-size: 10px;
}
```

--------------------------------

TITLE: Complete Example: Creating Elements with createElement
DESCRIPTION: A full, runnable example demonstrating the use of `createElement` to define a `Greeting` component and render it within an `App` component, including associated CSS styling.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/reference/react/createElement.md#_snippet_4

LANGUAGE: js
CODE:
```
import { createElement } from 'react';

function Greeting({ name }) {
  return createElement(
    'h1',
    { className: 'greeting' },
    'Hello ',
    createElement('i', null, name),
    '. Welcome!'
  );
}

export default function App() {
  return createElement(
    Greeting,
    { name: 'Taylor' }
  );
}
```

LANGUAGE: css
CODE:
```
.greeting {
  color: darkgreen;
  font-family: Georgia;
}
```

--------------------------------

TITLE: Configure React Compiler with Vite using @vitejs/plugin-react
DESCRIPTION: Example `vite.config.js` showing how to integrate `babel-plugin-react-compiler` into your Vite project when using `@vitejs/plugin-react`. The compiler plugin is passed via the `babel` option of the `react` plugin.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/learn/react-compiler/installation.md#_snippet_2

LANGUAGE: JavaScript
CODE:
```
// vite.config.js
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [
    react({
      babel: {
        plugins: ['babel-plugin-react-compiler'],
      },
    }),
  ],
});
```

--------------------------------

TITLE: Complete React Application for Data Filtering and Display
DESCRIPTION: This comprehensive example provides a full React application demonstrating data filtering, mapping, and display. It includes the main `App.js` component, a separate `data.js` file for structured data, a `utils.js` file for helper functions, and `style.css` for styling. This setup illustrates best practices for organizing a React project that processes and renders dynamic content.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/learn/rendering-lists.md#_snippet_7

LANGUAGE: JavaScript
CODE:
```
import { people } from './data.js';
import { getImageUrl } from './utils.js';

export default function List() {
  const chemists = people.filter(person =>
    person.profession === 'chemist'
  );
  const listItems = chemists.map(person =>
    <li>
      <img
        src={getImageUrl(person)}
        alt={person.name}
      />
      <p>
        <b>{person.name}:</b>
        {' ' + person.profession + ' '}
        known for {person.accomplishment}
      </p>
    </li>
  );
  return <ul>{listItems}</ul>;
}
```

LANGUAGE: JavaScript
CODE:
```
export const people = [{
  id: 0,
  name: 'Creola Katherine Johnson',
  profession: 'mathematician',
  accomplishment: 'spaceflight calculations',
  imageId: 'MK3eW3A'
}, {
  id: 1,
  name: 'Mario José Molina-Pasquel Henríquez',
  profession: 'chemist',
  accomplishment: 'discovery of Arctic ozone hole',
  imageId: 'mynHUSa'
}, {
  id: 2,
  name: 'Mohammad Abdus Salam',
  profession: 'physicist',
  accomplishment: 'electromagnetism theory',
  imageId: 'bE7W1ji'
}, {
  id: 3,
  name: 'Percy Lavon Julian',
  profession: 'chemist',
  accomplishment: 'pioneering cortisone drugs, steroids and birth control pills',
  imageId: 'IOjWm71'
}, {
  id: 4,
  name: 'Subrahmanyan Chandrasekhar',
  profession: 'astrophysicist',
  accomplishment: 'white dwarf star mass calculations',
  imageId: 'lrWQx8l'
}];
```

LANGUAGE: JavaScript
CODE:
```
export function getImageUrl(person) {
  return (
    'https://i.imgur.com/' +
    person.imageId +
    's.jpg'
  );
}
```

LANGUAGE: CSS
CODE:
```
ul { list-style-type: none; padding: 0px 10px; }
li { 
  margin-bottom: 10px; 
  display: grid; 
  grid-template-columns: auto 1fr;
  gap: 20px;
  align-items: center;
}
img { width: 100px; height: 100px; border-radius: 50%; }
```

--------------------------------

TITLE: Complete Example: Creating Elements with JSX
DESCRIPTION: A full, runnable example demonstrating the use of JSX to define a `Greeting` component and render it within an `App` component, including associated CSS styling, for direct comparison with the `createElement` approach.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/reference/react/createElement.md#_snippet_5

LANGUAGE: js
CODE:
```
function Greeting({ name }) {
  return (
    <h1 className="greeting">
      Hello <i>{name}</i>. Welcome!
    </h1>
  );
}

export default function App() {
  return <Greeting name="Taylor" />;
}
```

LANGUAGE: css
CODE:
```
.greeting {
  color: darkgreen;
  font-family: Georgia;
}
```

--------------------------------

TITLE: Install React.dev Website Dependencies
DESCRIPTION: Navigate into the project's root directory and install all required npm dependencies for the website using Yarn. This step is essential before running the development server or making any changes.

SOURCE: https://github.com/reactjs/react.dev/blob/main/README.md#_snippet_0

LANGUAGE: shell
CODE:
```
cd react.dev
```

LANGUAGE: shell
CODE:
```
yarn
```

--------------------------------

TITLE: Run React.dev Development Server Locally
DESCRIPTION: Start the development server, powered by Next.js, to view the website locally. After the server starts, open the provided URL in your browser to access the site. Changes to source files will typically hot-reload.

SOURCE: https://github.com/reactjs/react.dev/blob/main/README.md#_snippet_1

LANGUAGE: shell
CODE:
```
yarn dev
```

LANGUAGE: shell
CODE:
```
open http://localhost:3000
```

--------------------------------

TITLE: Install React Compiler Beta for React Applications
DESCRIPTION: Instructions for installing the beta version of `babel-plugin-react-compiler` and `eslint-plugin-react-compiler`. This build-time tool optimizes React apps through automatic memoization and is intended for early adopters and library maintainers.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/blog/2024/10/21/react-compiler-beta-release.md#_snippet_0

LANGUAGE: bash
CODE:
```
npm install -D babel-plugin-react-compiler@beta eslint-plugin-react-compiler@beta
```

LANGUAGE: bash
CODE:
```
yarn add -D babel-plugin-react-compiler@beta eslint-plugin-react-compiler@beta
```

--------------------------------

TITLE: Install React and React DOM with npm
DESCRIPTION: This command installs the `react` and `react-dom` packages from the npm registry into your project. These are essential dependencies for building React applications and enable you to use React's core functionalities.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/learn/add-react-to-an-existing-project.md#_snippet_0

LANGUAGE: Shell
CODE:
```
npm install react react-dom
```

--------------------------------

TITLE: Display complex data and dynamic styles in React
DESCRIPTION: This example demonstrates how to display complex data, including images and dynamic text, and apply inline styles based on JavaScript variables within a React component. It also shows how to define corresponding CSS rules.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/learn/index.md#_snippet_8

LANGUAGE: js
CODE:
```
const user = {
  name: 'Hedy Lamarr',
  imageUrl: 'https://i.imgur.com/yXOvdOSs.jpg',
  imageSize: 90,
};

export default function Profile() {
  return (
    <>
      <h1>{user.name}</h1>
      <img
        className="avatar"
        src={user.imageUrl}
        alt={'Photo of ' + user.name}
        style={{
          width: user.imageSize,
          height: user.imageSize
        }}
      />
    </>
  );
}
```

LANGUAGE: css
CODE:
```
.avatar {
  border-radius: 50%;
}

.large {
  border: 4px solid gold;
}
```

--------------------------------

TITLE: Preiniting an External Script During React Rendering
DESCRIPTION: This example demonstrates how to use `preinit` to eagerly fetch and evaluate an external JavaScript file when a React component renders. This provides a hint to the browser to start downloading and executing the script early, optimizing the application's initial load performance.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/reference/react-dom/preinit.md#_snippet_0

LANGUAGE: js
CODE:
```
import { preinit } from 'react-dom';

function AppRoot() {
  preinit("https://example.com/script.js", {as: "script"});
  return ...;
}
```

--------------------------------

TITLE: Install React Compiler Development Dependency
DESCRIPTION: Commands to install the `babel-plugin-react-compiler` package as a development dependency using npm, Yarn, or pnpm. The `@rc` tag ensures the installation of the latest release candidate version.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/learn/react-compiler/installation.md#_snippet_0

LANGUAGE: npm
CODE:
```
npm install -D babel-plugin-react-compiler@rc
```

LANGUAGE: Yarn
CODE:
```
yarn add -D babel-plugin-react-compiler@rc
```

LANGUAGE: pnpm
CODE:
```
pnpm install -D babel-plugin-react-compiler@rc
```

--------------------------------

TITLE: Define project dependencies and scripts (JSON)
DESCRIPTION: This `package.json` file outlines the project's dependencies, including React, React DOM, Leaflet, and React Scripts. It also defines standard npm scripts for starting, building, testing, and ejecting the project, setting up the development environment for the React-Leaflet integration example.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/reference/react-dom/createPortal.md#_snippet_9

LANGUAGE: json
CODE:
```
{
  "dependencies": {
    "leaflet": "1.9.1",
    "react": "latest",
    "react-dom": "latest",
    "react-scripts": "latest",
    "remarkable": "2.0.1"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test --env=jsdom",
    "eject": "react-scripts eject"
  }
}
```

--------------------------------

TITLE: Load React 19 and ReactDOM via ESM CDN
DESCRIPTION: This example demonstrates how to import React 19 and ReactDOMClient directly into an HTML page using an ESM-based CDN like esm.sh. This approach replaces the previously used UMD builds, which have been removed in React 19, providing a modern way to load React without a build step.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/blog/2024/04/25/react-19-upgrade-guide.md#_snippet_17

LANGUAGE: html
CODE:
```
<script type="module">
  import React from "https://esm.sh/react@19/?dev"
  import ReactDOMClient from "https://esm.sh/react-dom@19/client?dev"
  ...
</script>
```

--------------------------------

TITLE: Implement React useEffect for External System Synchronization
DESCRIPTION: This example demonstrates using `useEffect` within a React component to manage a connection to an external chat system. It shows how to establish a connection in the `setup` function and provide a `cleanup` function to disconnect when the component unmounts or dependencies change, ensuring proper resource handling.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/reference/react/useEffect.md#_snippet_1

LANGUAGE: js
CODE:
```
import { useState, useEffect } from 'react';
import { createConnection } from './chat.js';

function ChatRoom({ roomId }) {
  const [serverUrl, setServerUrl] = useState('https://localhost:1234');

  useEffect(() => {
    const connection = createConnection(serverUrl, roomId);
    connection.connect();
    return () => {
      connection.disconnect();
    };
  }, [serverUrl, roomId]);
  // ...
}
```

--------------------------------

TITLE: Initial React Root Setup (Clears HTML)
DESCRIPTION: This JavaScript code demonstrates an initial, basic way to set up a React root and render a component. It clears the entire `document.body` before rendering, which is generally not suitable for integrating React into existing HTML pages incrementally.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/learn/add-react-to-an-existing-project.md#_snippet_2

LANGUAGE: js
CODE:
```
import { createRoot } from 'react-dom/client';

// Clear the existing HTML content
document.body.innerHTML = '<div id="app"></div>';

// Render your React component instead
const root = createRoot(document.getElementById('app'));
root.render(<h1>Hello, world</h1>);
```

--------------------------------

TITLE: Migrate to and Configure eslint-plugin-react-hooks RC
DESCRIPTION: This snippet details the migration process from `eslint-plugin-react-compiler` to `eslint-plugin-react-hooks@rc`. It includes installation commands for npm, pnpm, and Yarn, followed by JavaScript examples for configuring ESLint to enable the React Hooks plugin, supporting both Flat Config (ESLint 9+) and Legacy Config.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/blog/2025/04/21/react-compiler-rc.md#_snippet_1

LANGUAGE: npm
CODE:
```
npm install --save-dev eslint-plugin-react-hooks@rc
```

LANGUAGE: pnpm
CODE:
```
pnpm add --save-dev eslint-plugin-react-hooks@rc
```

LANGUAGE: yarn
CODE:
```
yarn add --dev eslint-plugin-react-hooks@rc
```

LANGUAGE: javascript
CODE:
```
// eslint.config.js
import * as reactHooks from 'eslint-plugin-react-hooks';

export default [
  // Flat Config (eslint 9+)
  reactHooks.configs.recommended,

  // Legacy Config
  reactHooks.configs['recommended-latest']
];
```

--------------------------------

TITLE: Migrate `ReactDOM.render` to `ReactDOM.createRoot` in React 19
DESCRIPTION: `ReactDOM.render` is removed in React 19. This example shows how to refactor your application's entry point to use `ReactDOM.createRoot` for initial rendering, which is the modern approach for React 18+ applications. A codemod is provided for automated migration.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/blog/2024/04/25/react-19-upgrade-guide.md#_snippet_13

LANGUAGE: javascript
CODE:
```
// Before
import {render} from 'react-dom';
render(<App />, document.getElementById('root'));

// After
import {createRoot} from 'react-dom/client';
const root = createRoot(document.getElementById('root'));
root.render(<App />);
```

LANGUAGE: bash
CODE:
```
npx codemod@latest react/19/replace-reactdom-render
```

--------------------------------

TITLE: Complete React Application with Custom Error Overlay
DESCRIPTION: This comprehensive example provides a full React application demonstrating a custom error overlay. It includes CSS for styling, HTML for the dialog structure, and multiple JavaScript files for patching `console.error` (similar to the standalone example), handling error display, and a simple component to trigger an error. This setup allows developers to see the `captureOwnerStack` functionality in action within a complete, runnable environment.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/reference/react/captureOwnerStack.md#_snippet_4

LANGUAGE: css
CODE:
```
* {
  box-sizing: border-box;
}

body {
  font-family: sans-serif;
  margin: 20px;
  padding: 0;
}

h1 {
  margin-top: 0;
  font-size: 22px;
}

h2 {
  margin-top: 0;
  font-size: 20px;
}

code {
  font-size: 1.2em;
}

ul {
  padding-inline-start: 20px;
}

label, button { display: block; margin-bottom: 20px; }
html, body { min-height: 300px; }

#error-dialog {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  background-color: white;
  padding: 15px;
  opacity: 0.9;
  text-wrap: wrap;
  overflow: scroll;
}

.text-red {
  color: red;
}

.-mb-20 {
  margin-bottom: -20px;
}

.mb-0 {
  margin-bottom: 0;
}

.mb-10 {
  margin-bottom: 10px;
}

pre {
  text-wrap: wrap;
}

pre.nowrap {
  text-wrap: nowrap;
}

.hidden {
 display: none;  
}
```

LANGUAGE: html
CODE:
```
<!DOCTYPE html>
<html>
<head>
  <title>My app</title>
</head>
<body>
<!--
  Error dialog in raw HTML
  since an error in the React app may crash.
-->
<div id="error-dialog" class="hidden">
  <h1 id="error-title" class="text-red">Error</h1>
  <p>
    <pre id="error-body"></pre>
  </p>
  <h2 class="-mb-20">Owner Stack:</h4>
  <pre id="error-owner-stack" class="nowrap"></pre>
  <button
    id="error-close"
    class="mb-10"
    onclick="document.getElementById('error-dialog').classList.add('hidden')"
  >
    Close
  </button>
</div>
<!-- This is the DOM node -->
<div id="root"></div>
</body>
</html>

```

LANGUAGE: javascript
CODE:
```

export function onConsoleError({ consoleMessage, ownerStack }) {
  const errorDialog = document.getElementById("error-dialog");
  const errorBody = document.getElementById("error-body");
  const errorOwnerStack = document.getElementById("error-owner-stack");

  // Display console.error() message
  errorBody.innerText = consoleMessage;

  // Display owner stack
  errorOwnerStack.innerText = ownerStack;

  // Show the dialog
  errorDialog.classList.remove("hidden");
}
```

LANGUAGE: javascript
CODE:
```
import { captureOwnerStack } from "react";
import { createRoot } from "react-dom/client";
import App from './App';
import { onConsoleError } from "./errorOverlay";
import './styles.css';

const originalConsoleError = console.error;
console.error = function patchedConsoleError(...args) {
  originalConsoleError.apply(console, args);
  const ownerStack = captureOwnerStack();
  onConsoleError({
    // Keep in mind that in a real application, console.error can be
    // called with multiple arguments which you should account for.
    consoleMessage: args[0],
    ownerStack,
  });
};

const container = document.getElementById("root");
createRoot(container).render(<App />);
```

LANGUAGE: javascript
CODE:
```
function Component() {
  return <button onClick={() => console.error('Some console error')}>Trigger console.error()</button>;
}

export default function App() {
  return <Component />;
}
```

--------------------------------

TITLE: Triggering React Component Animation with useEffect and External Library
DESCRIPTION: This example demonstrates how to integrate an external JavaScript animation library (`FadeInAnimation`) with a React component. It uses `useRef` to get a reference to the DOM node and `useEffect` to start the animation when the component mounts and clean it up when it unmounts. The `FadeInAnimation` class manages the animation state and applies styles to the DOM node.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/reference/react/useEffect.md#_snippet_5

LANGUAGE: javascript
CODE:
```
import { useState, useEffect, useRef } from 'react';
import { FadeInAnimation } from './animation.js';

function Welcome() {
  const ref = useRef(null);

  useEffect(() => {
    const animation = new FadeInAnimation(ref.current);
    animation.start(1000);
    return () => {
      animation.stop();
    };
  }, []);

  return (
    <h1
      ref={ref}
      style={{
        opacity: 0,
        color: 'white',
        padding: 50,
        textAlign: 'center',
        fontSize: 50,
        backgroundImage: 'radial-gradient(circle, rgba(63,94,251,1) 0%, rgba(252,70,107,1) 100%)'
      }}
    >
      Welcome
    </h1>
  );
}

export default function App() {
  const [show, setShow] = useState(false);
  return (
    <>
      <button onClick={() => setShow(!show)}>
        {show ? 'Remove' : 'Show'}
      </button>
      <hr />
      {show && <Welcome />}
    </>
  );
}
```

LANGUAGE: javascript
CODE:
```
export class FadeInAnimation {
  constructor(node) {
    this.node = node;
  }
  start(duration) {
    this.duration = duration;
    if (this.duration === 0) {
      // Jump to end immediately
      this.onProgress(1);
    } else {
      this.onProgress(0);
      // Start animating
      this.startTime = performance.now();
      this.frameId = requestAnimationFrame(() => this.onFrame());
    }
  }
  onFrame() {
    const timePassed = performance.now() - this.startTime;
    const progress = Math.min(timePassed / this.duration, 1);
    this.onProgress(progress);
    if (progress < 1) {
      // We still have more frames to paint
      this.frameId = requestAnimationFrame(() => this.onFrame());
    }
  }
  onProgress(progress) {
    this.node.style.opacity = progress;
  }
  stop() {
    cancelAnimationFrame(this.frameId);
    this.startTime = null;
    this.frameId = null;
    this.duration = 0;
  }
}
```

LANGUAGE: css
CODE:
```
label, button { display: block; margin-bottom: 20px; }
html, body { min-height: 300px; }
```

--------------------------------

TITLE: React: Complete Example of useSyncExternalStore with Custom Store
DESCRIPTION: Provides a comprehensive example of integrating a React component with a custom external data store using `useSyncExternalStore`. It includes the `TodosApp` component that interacts with the store and the implementation of a simple `todosStore.js` for managing todo items, demonstrating subscription, snapshot retrieval, and state updates.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/reference/react/useSyncExternalStore.md#_snippet_4

LANGUAGE: javascript
CODE:
```
import { useSyncExternalStore } from 'react';
import { todosStore } from './todoStore.js';

export default function TodosApp() {
  const todos = useSyncExternalStore(todosStore.subscribe, todosStore.getSnapshot);
  return (
    <>
      <button onClick={() => todosStore.addTodo()}>Add todo</button>
      <hr />
      <ul>
        {todos.map(todo => (
          <li key={todo.id}>{todo.text}</li>
        ))}
      </ul>
    </>
  );
}
```

LANGUAGE: javascript
CODE:
```
// This is an example of a third-party store
// that you might need to integrate with React.

// If your app is fully built with React,
// we recommend using React state instead.

let nextId = 0;
let todos = [{ id: nextId++, text: 'Todo #1' }];
let listeners = [];

export const todosStore = {
  addTodo() {
    todos = [...todos, { id: nextId++, text: 'Todo #' + nextId }]
    emitChange();
  },
  subscribe(listener) {
    listeners = [...listeners, listener];
    return () => {
      listeners = listeners.filter(l => l !== listener);
    };
  },
  getSnapshot() {
    return todos;
  }
};

function emitChange() {
  for (let listener of listeners) {
    listener();
  }
}
```

--------------------------------

TITLE: Representing Static Data as an HTML List
DESCRIPTION: This example illustrates a basic static HTML unordered list, serving as a conceptual starting point for understanding how data might be structured before being dynamically rendered by React components. It highlights the raw data format that will later be processed.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/learn/rendering-lists.md#_snippet_0

LANGUAGE: HTML
CODE:
```
<ul>
  <li>Creola Katherine Johnson: mathematician</li>
  <li>Mario José Molina-Pasquel Henríquez: chemist</li>
  <li>Mohammad Abdus Salam: physicist</li>
  <li>Percy Lavon Julian: chemist</li>
  <li>Subrahmanyan Chandrasekhar: astrophysicist</li>
</ul>
```

--------------------------------

TITLE: CSS Styling for React Sidebar Examples
DESCRIPTION: Provides the necessary CSS styles for the React sidebar components and the overall layout of the application examples. It includes styling for the navigation, buttons, indicators, and main content area.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/reference/react/Activity.md#_snippet_5

LANGUAGE: css
CODE:
```
body { height: 275px; margin: 0; }
#root {
  display: flex;
  gap: 10px;
  height: 100%;
}
nav {
  padding: 10px;
  background: #eee;
  font-size: 14px;
  height: 100%;
}
main {
  padding: 10px;
}
p {
  margin: 0;
}
h1 {
  margin-top: 10px;
}
.indicator {
  margin-left: 4px;
  display: inline-block;
  rotate: 90deg;
}
.indicator.down {
  rotate: 180deg;
}
```

--------------------------------

TITLE: Initialize a React application with createRoot
DESCRIPTION: This JavaScript code demonstrates how to create a React root using `createRoot` from `react-dom/client`. It finds a specific DOM element by its ID ('root') and renders the main `<App />` component into it, effectively bootstrapping the entire React application. This setup is typically executed once at application startup.

SOURCE: https://github.com/reactjs/react.dev/blob/main/src/content/reference/react-dom/client/createRoot.md#_snippet_3

LANGUAGE: javascript
CODE:
```
import { createRoot } from 'react-dom/client';

const root = createRoot(document.getElementById('root'));
root.render(<App />);
```