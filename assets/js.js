const data = {{data}}
const cookies = data.cookies
const headers = data.headers

if (Object.entries(cookies).length === 0) {
	document.querySelector('section.cookies-section').style.display = 'none'
}

if (Object.entries(headers).length === 0) {
	document.querySelector('section.headers-section').style.display = 'none'
}

Object.entries(cookies).map((cookie) => {
	const table = document.querySelector('table.cookies')

	const row = document.createElement('tr')
	const title = document.createElement('td')
	const value = document.createElement('td')

	title.classList.add('title')
	title.textContent = cookie[0]
	value.textContent = cookie[1]

	row.appendChild(title)
	row.appendChild(value)
	table.appendChild(row)
})

Object.entries(headers).map((header) => {
	if (header[0] === 'cookie') {
		return
	}

	const table = document.querySelector('table.headers')

	const row = document.createElement('tr')
	const title = document.createElement('td')
	const value = document.createElement('td')

	title.classList.add('title')
	title.textContent = header[0]
	value.textContent = header[1]

	row.appendChild(title)
	row.appendChild(value)
	table.appendChild(row)
})

document.querySelector('h3.error-status').textContent = data.status
document.querySelector('h4.error-name').textContent = data.name
document.querySelector('h2.error-message').textContent = data.message
document.querySelector('td.uri').textContent = data.uri
document.querySelector('td.method').textContent = data.method
document.querySelector('td.version').textContent = data.httpVersion
document.querySelector('td.connection').textContent = data.connection

const frames = document.querySelector('div.frames-list')

data.stack.forEach((frame) => {
	const row = document.createElement('div')
	const filepath = document.createElement('div')
	const code = document.createElement('div')
	const context = document.createElement('div')

	filepath.textContent = `${frame.path}:${frame.lineNo}:${frame.columnNo}`
	code.textContent = frame.method

	row.setAttribute('class', frame.path.startsWith('node_modules') ? 'frame-row native-frame force-show' : 'frame-row')
	filepath.setAttribute('class', 'frame-row-filepath')
	code.setAttribute('class', 'frame-row-code')
	context.setAttribute('class', 'frame-context')

	row.appendChild(filepath)
	row.appendChild(code)
	row.appendChild(context)

	frames.appendChild(row)
})
