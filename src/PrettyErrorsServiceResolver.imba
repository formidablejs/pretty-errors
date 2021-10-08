import {
	FormRequest
	FastifyReply
	helpers
	ServiceResolver
} from '@formidablejs/framework'

import Youch from 'youch'

export default class PrettyErrorsServiceResolver < ServiceResolver

	def boot
		self.app.onResponse do(response, request\FormRequest, reply\FastifyReply)
			if response instanceof Error && self.app.config.get('app.debug', false) && !request.expectsJson!
				if helpers.isEmpty(response.status)
					response.status = 500

				const youch = new Youch(response, request.request.raw)

				return youch.toHTML!.then do(html)
					reply.header('Content-Type', 'text/html')
					reply.send(html)
					reply.sent = true

		self
