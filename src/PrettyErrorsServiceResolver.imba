import { FastifyReply } from '@formidablejs/framework'
import { FormRequest } from '@formidablejs/framework'
import { helpers } from '@formidablejs/framework'
import { ServiceResolver } from '@formidablejs/framework'
import { ValidationException } from '@formidablejs/framework'
import fs from 'fs'
import path from 'path'
import Youch from 'youch'

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
			return self.handleDevelopmentErrors(response, request, reply)

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

		return reply.header('Content-Type', 'text/html')
			.code(statusCode)
			.send(html)
			.sent = true

	def handleDevelopmentErrors response\Error, request\FormRequest, reply\FastifyReply
		if helpers.isEmpty(response.status)
			response.status = 500

		const youch = new Youch(response, request.request.raw)

		return youch.toHTML!.then do(html)
			reply.header('Content-Type', 'text/html')
			reply.send(html)
			reply.sent = true
