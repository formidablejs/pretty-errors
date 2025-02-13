import { FastifyReply } from '@formidablejs/framework'
import { FormRequest } from '@formidablejs/framework'
import { helpers } from '@formidablejs/framework'
import { ServiceResolver } from '@formidablejs/framework'
import { ValidationException } from '@formidablejs/framework'
import { Response } from './Response'
import { sendError } from './error'
import fs from 'fs'
import path from 'path'

export default class PrettyErrorsServiceResolver < ServiceResolver

	def boot
		self.app.addHook 'onMaintenance', do(response\Error, request\FormRequest, reply\FastifyReply)
			self.modifyHeaders(response, request, reply)

			if response instanceof Error && !request.expectsJson!
				self.handleProductionErrors(response, request, reply)

		self.app.onResponse do(response, request\FormRequest, reply\FastifyReply)
			self.modifyHeaders(response, request, reply)

			if response instanceof Error && !request.expectsJson!
				self.errorHandler(response, request, reply)

	def modifyHeaders response, request, reply
		if request.hasHeader('x-formidable-request') && response instanceof Error && !(response instanceof ValidationException)
			request.req.headers['accept'] = 'text/html'
			reply.header('accept','text/html')

	def errorHandler response\Error, request\FormRequest, reply\FastifyReply
		if self.app.config.get('app.debug', false)
			return Array.isArray(process.argv) && process.argv.length > 1 && process.argv[1].slice(-9) == 'server.js' ? self.handleDevelopmentErrors(response, request, reply) : sendError(response, request, reply)
		else
			return self.handleProductionErrors(response, request, reply)

	def handleProductionErrors response\Error, request\FormRequest, reply\FastifyReply
		const statusCode\Number = helpers.isEmpty(response.status) ? 500 : response.status
		const message\String = statusCode == 500 ? 'Internal Server Error' : ( statusCode == 404 ? 'Not Found' : response.message)

		const errorPage\String = path.join(__dirname, '..', 'assets', 'error.html')

		let html\String = message

		if fs.existsSync(errorPage)
			html = fs.readFileSync(errorPage, 'utf8')
			html = html.replace(/{{statusCode}}/g, statusCode)
			html = html.replace(/{{message}}/g, message)

		new Response(html, statusCode)

	def handleDevelopmentErrors response\Error, request\FormRequest, reply\FastifyReply
		if helpers.isEmpty(response.status)
			response.status = 500

		# patch crypto
		const crypto = require('crypto')
		globalThis.crypto = crypto

		# use import instead of require
		const { Youch } = await import('youch')
		const youch = new Youch()

		const html = await youch.toHTML(cleanUpErrorStack(response), {
			title: 'Internal Server Error',
			request: request.request.raw,
		})

		new Response(html, response.status)

	def cleanUpErrorStack error\Error
		if process.env.FRAMEWORK_DEBUG == 'true' || process.env.FRAMEWORK_DEBUG == true
			return error

		if error instanceof Error
			if !error.stack then return error

			const regex = /at (Object\.getResponse \[as default\]|Object\.handler|preHandlerCallback|next|handleResolve) \([^\)]+(\/(node_modules\/@formidablejs\/framework\/lib\/Http\/Kernel\/getResponse\.js|node_modules\/@formidablejs\/framework\/lib\/Http\/Kernel\.js|fastify\/lib\/handleRequest\.js|fastify\/lib\/hooks\.js))[^)]+\)/g

			error.stack = error.stack.replace(regex, '').trim()

			return error

		return error
