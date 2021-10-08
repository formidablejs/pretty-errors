# Formidable Pretty Errors

Pretty error reporting for Formidable.

<br />

![Uh-oh!](youch.png)

------

![npm](https://img.shields.io/npm/v/@formidablejs/pretty-errors)
![NPM](https://img.shields.io/npm/l/@formidablejs/pretty-errors)

## Requirements

  * [@formidablejs/framework](https://www.npmjs.com/package/@formidablejs/framework): `>=0.5.0-alpha.1`

## Install

npm:

```bash
npm i @formidablejs/pretty-errors
```

yarn:

```bash
yarn add @formidablejs/pretty-errors
```

## Configuration

Add `PrettyErrorsServiceResolver` in the `config/app.imba` config under `resolvers`:

```js
...

resolvers: {
	...
	require('@formidablejs/pretty-errors').PrettyErrorsServiceResolver
```

## Credits

This Formidable plugin uses [youch](https://github.com/poppinss/youch) under the hood.

## License

The Formidable framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
