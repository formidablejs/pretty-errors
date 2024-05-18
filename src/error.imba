import { FastifyReply, FormRequest, helpers } from '@formidablejs/framework'
import { HtmlResponse } from './HtmlResponse'

let html = '<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<title> </title>
	<link href="https://fonts.bunny.net/css2?family=Source+Sans+Pro:300,400,500,600" rel="stylesheet">

	<style type="text/css">
		html,
		body {
			height: 100%;
			width: 100%;
		}

		body {
			font-family: "Source Sans Pro", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
			font-size: 14px;
			line-height: 24px;
			color: #444;
		}

		.fab {
			font-family: "Font Awesome 5 Brands";
			-webkit-font-smoothing: antialiased;
			color: #afafaf;
			font-size: 24px;
		}

		* {
			padding: 0;
			margin: 0;
		}

		.error-page {
			display: flex;
			flex-direction: column;
			width: 100%;
			height: 100%;
		}

		.error-stack {
			background: #edecea;
			padding: 100px 80px;
			box-sizing: border-box;
		}

		.error-status {
			color: #afafaf;
			font-size: 150px;
			position: absolute;
			opacity: 0.2;
			right: 80px;
			top: 80px;
			font-weight: 600;
			margin-bottom: 10px;
		}

		.error-name {
			color: #db5461;
			font-size: 18px;
			font-family: Menlo, SFMono-Regular, Monaco, "Fira Code", "Fira Mono", Consolas, "Liberation Mono", "Courier New", monospace;
			font-weight: 600;
			margin-bottom: 15px;
		}

		.error-message {
			font-weight: 300;
			font-size: 40px;
			line-height: 48px;
		}

		.error-title {
			border-bottom: 1px solid #d0cfcf;
			padding-bottom: 15px;
			margin-bottom: 20px;
		}

		.error-links {
			margin-top: 20px;
		}

		.error-links a {
			margin-right: 8px;
		}

		.error-frames {
			display: flex;
			flex-direction: row-reverse;
		}

		.frame-preview {
			background: #fff;
			width: 50%;
			box-shadow: 0px 0px 9px #d3d3d3;
			height: 100%;
			box-sizing: border-box;
			overflow: auto;
		}

		.frame-stack {
			margin-right: 40px;
			flex: 1;
			padding: 10px 0;
			box-sizing: border-box;
		}

		.frames-list {
			overflow: auto;
			max-height: 334px;
		}

		.frames-filter-selector {
			margin-bottom: 30px;
			margin-left: 8px;
		}

		.request-details {
			padding: 50px 80px;
		}

		.request-title {
			text-transform: uppercase;
			font-size: 18px;
			letter-spacing: 1px;
			padding: 0 5px 5px 5px;
			margin-bottom: 15px;
		}

		.request-details table {
			width: 100%;
			border-collapse: collapse;
			margin-bottom: 80px;
		}

		.request-details table td {
			padding: 6px 5px;
			font-size: 14px;
			letter-spacing: 0.4px;
			color: #455275;
			border-bottom: 1px solid #e8e8e8;
			word-break: break-word;
		}

		.request-details table td.title {
			color: #999;
			width: 40%;
			font-size: 14px;
			font-weight: 600;
			text-transform: uppercase;
		}

		code[class*="language-"],
		pre[class*="language-"] {
			background: transparent;
			font-size: 13px;
			line-height: 1.8;
		}

		.line-numbers .line-numbers-rows {
			border: none;
		}

		.frame-row {
			display: flex;
			justify-content: space-between;
			padding: 6px 34px 6px 10px;
			position: relative;
			cursor: pointer;
			transition: background 300ms ease;
		}

		.frame-row.native-frame {
			display: none;
			opacity: 0.4;
		}

		.frame-row.native-frame.force-show {
			display: flex;
		}

		.frame-row:after {
			content: "";
			background: #db5461;
			position: absolute;
			top: 50%;
			right: 10px;
			transform: translateY(-50%);
			height: 10px;
			width: 10px;
			border-radius: 24px;
		}

		.frame-row:hover,
		.frame-row.active {
			background: #fff;
		}

		.frame-row.active {
			opacity: 1;
		}

		.frame-row-filepath {
			color: #455275;
			font-weight: 600;
			margin-right: 15px;
		}

		.frame-context {
			display: none;
		}

		.frame-row-code {
			color: #999;
		}

		#frame-file {
			color: #455275;
			font-weight: 600;
			border-bottom: 1px solid #e8e8e8;
			padding: 10px 22px;
		}

		#frame-method {
			color: #999;
			font-weight: 400;
			border-top: 1px solid #e8e8e8;
			padding: 10px 22px;
		}

		.is-hidden {
			display: none;
		}

		@media only screen and (max-width: 970px) {
			.error-frames {
				flex-direction: column-reverse;
			}

			.frame-preview {
				width: 100%;
			}

			.frame-stack {
				width: 100%;
			}
		}
	</style>

</head>

<body>
	<section class="error-page">
		<section class="error-stack">
			<h3 class="error-status">{{status}}</h3>

			<div class="error-title">
				<h4 class="error-name">{{error}}</h4>
				<h2 class="error-message">{{message}}</h2>
				<p class="error-links">
				</p>
			</div>

			<div class="error-frames">
				<div class="frame-preview is-hidden">
					<div id="frame-file"></div>
					<div id="frame-code">
						<pre class="line-numbers"><code class="language-js" id="code-drop"></code></pre>
					</div>
					<div id="frame-method"></div>
				</div>

				<div class="frame-stack">
					<div class="frames-list">

					</div>
				</div>
			</div>
		</section>

		<section class="request-details">
			<h2 class="request-title"> Request Details </h2>

			<table>
				<tr>
					<td class="title"> URI </td>
					<td class="uri"> {{uri}} </td>
				</tr>

				<tr>
					<td class="title"> Request Method </td>
					<td class="method"> {{method}} </td>
				</tr>

				<tr>
					<td class="title"> HTTP Version </td>
					<td class="version"> {{version}} </td>
				</tr>

				<tr>
					<td class="title"> Connection </td>
					<td class="connection"> {{connection}} </td>
				</tr>
			</table>

			<section class="headers-section">
				<h2 class="request-title"> Headers </h2>
				<table class="headers">
				</table>
			</section>

			<section class="cookies-section">
				<h2 class="request-title"> Cookies </h2>
				<table class="cookies">
				</table>
			</section>

		</section>
	</section>

	<script>
		const e = {{data}}, t = e.cookies, n = e.headers; 0 === Object.entries(t).length && (document.querySelector("section.cookies-section").style.display = "none"), 0 === Object.entries(n).length && (document.querySelector("section.headers-section").style.display = "none"), Object.entries(t).map((e => { const t = document.querySelector("table.cookies"), n = document.createElement("tr"), o = document.createElement("td"), c = document.createElement("td"); o.classList.add("title"), o.textContent = e[0], c.textContent = e[1], n.appendChild(o), n.appendChild(c), t.appendChild(n) })), Object.entries(n).map((e => { if ("cookie" === e[0]) return; const t = document.querySelector("table.headers"), n = document.createElement("tr"), o = document.createElement("td"), c = document.createElement("td"); o.classList.add("title"), o.textContent = e[0], c.textContent = e[1], n.appendChild(o), n.appendChild(c), t.appendChild(n) })), document.querySelector("h3.error-status").textContent = e.status, document.querySelector("h4.error-name").textContent = e.name, document.querySelector("h2.error-message").textContent = e.message, document.querySelector("td.uri").textContent = e.uri, document.querySelector("td.method").textContent = e.method, document.querySelector("td.version").textContent = e.httpVersion, document.querySelector("td.connection").textContent = e.connection; const o = document.querySelector("div.frames-list"); e.stack.forEach((e => { const t = document.createElement("div"), n = document.createElement("div"), c = document.createElement("div"), r = document.createElement("div"); n.textContent = `${e.path}:${e.lineNo}:${e.columnNo}`, c.textContent = e.method, t.setAttribute("class", e.path.startsWith("node_modules") ? "frame-row native-frame force-show" : "frame-row"), n.setAttribute("class", "frame-row-filepath"), c.setAttribute("class", "frame-row-code"), r.setAttribute("class", "frame-context"), t.appendChild(n), t.appendChild(c), t.appendChild(r), o.appendChild(t) }));
	</script>
</body>

</html>'

export def sendError error\Error, request\FormRequest, reply\FastifyReply
	if helpers.isEmpty(error.status)
		error.status = 500

	let stack = []

	error.stack.split('\n').map(do(line)
		if line.startsWith('    at ')
			let file = line.split('(')[1]

			if file
				file = file.split(')')[0].split(':')
				const path = file.slice(0, file.length - 2).join(':').slice(process.cwd().length + 1)
				const lineNo = file[file.length - 2]
				const columnNo = file[file.length - 1]
				const method = line.split(' ')[5]

				stack.push({
					path,
					lineNo,
					columnNo,
					method
				})
	)

	new HtmlResponse(html.replace('{{data}}', JSON.stringify({
		name: error.name,
		message: error.message,
		stack: stack,
		status: error.status,
		headers: request.headers(),
		cookies: request.req.cookies,
		uri: request.url(),
		method: request.method(),
		httpVersion: request.req.raw.httpVersion,
		connection: request.hasHeader('connection') ? request.header('connection') : 'unknown',
	})), error.status)
