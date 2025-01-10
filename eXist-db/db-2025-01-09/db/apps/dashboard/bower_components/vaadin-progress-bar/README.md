![Bower version](https://img.shields.io/bower/v/vaadin-progress-bar.svg)
[![npm version](https://badge.fury.io/js/%40vaadin%2Fvaadin-progress-bar.svg)](https://badge.fury.io/js/%40vaadin%2Fvaadin-progress-bar)
[![Published on webcomponents.org](https://img.shields.io/badge/webcomponents.org-published-blue.svg)](https://www.webcomponents.org/element/vaadin/vaadin-progress-bar)
[![Build Status](https://travis-ci.org/vaadin/vaadin-progress-bar.svg?branch=master)](https://travis-ci.org/vaadin/vaadin-progress-bar)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/vaadin/web-components?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

# &lt;vaadin-progress-bar&gt;

[Live Demo ↗](https://vaadin.com/components/vaadin-progress-bar/html-examples)
|
[API documentation ↗](https://vaadin.com/components/vaadin-progress-bar/html-api)

[&lt;vaadin-progress-bar&gt;](https://vaadin.com/components/vaadin-progress-bar) is a [Polymer 2](http://polymer-project.org) progress bar, part of the [Vaadin components](https://vaadin.com/components).

<!--
```
<custom-element-demo>
  <template>
    <script src="../webcomponentsjs/webcomponents-lite.js"></script>
    <link rel="import" href="vaadin-progress-bar.html">
    <next-code-block></next-code-block>
  </template>
</custom-element-demo>
```
-->

```html
<vaadin-progress-bar></vaadin-progress-bar>
<vaadin-progress-bar value="0.3"></vaadin-progress-bar>
<vaadin-progress-bar indeterminate></vaadin-progress-bar>
```

[<img src="https://raw.githubusercontent.com/vaadin/vaadin-progress-bar/master/screenshot.gif" width="418" alt="Screenshot of vaadin-progress-bar">](https://vaadin.com/components/vaadin-progress-bar)

## Getting Started

Vaadin components use the Lumo theme by default.

## The file structure for Vaadin components

- `src/vaadin-progress-bar.html`

  Unstyled component.

- `theme/lumo/vaadin-progress-bar.html`

  Component with Lumo theme.

- `vaadin-progress-bar.html`

  Alias for theme/lumo/vaadin-progress-bar.html

## Running demos and tests in browser

1. Fork the `vaadin-progress-bar` repository and clone it locally.

1. Make sure you have [npm](https://www.npmjs.com/) installed.

1. When in the `vaadin-progress-bar` directory, run `npm install` and then `bower install` to install dependencies.

1. Run `polymer serve --open`, browser will automatically open the component API documentation.

1. You can also open demo or in-browser tests by adding **demo** or **test** to the URL, for example:

  - http://127.0.0.1:8080/components/vaadin-progress-bar/demo
  - http://127.0.0.1:8080/components/vaadin-progress-bar/test


## Running tests from the command line

1. When in the `vaadin-progress-bar` directory, run `polymer test`


## Following the coding style

We are using [ESLint](http://eslint.org/) for linting JavaScript code. You can check if your code is following our standards by running `gulp lint`, which will automatically lint all `.js` files as well as JavaScript snippets inside `.html` files.


## Contributing

  - Make sure your code is compliant with our code linters: `gulp lint`
  - Check that tests are passing: `polymer test`
  - [Submit a pull request](https://www.digitalocean.com/community/tutorials/how-to-create-a-pull-request-on-github) with detailed title and description
  - Wait for response from one of Vaadin components team members


## License

Apache License 2.0

Vaadin collects development time usage statistics to improve this product. For details and to opt-out, see https://github.com/vaadin/vaadin-usage-statistics.
