import { Response, FastifyReply } from '@formidablejs/framework'

export class HtmlResponse < Response

	def toResponse reply\FastifyReply
		reply.code(this.statusCode)
		reply.header('Content-Type', 'text/html')

		reply.send(this.data)

