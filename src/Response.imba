import { Response as BaseResponse } from '@formidablejs/framework'

export class Response < BaseResponse

	def toResponse reply
		reply.header('Content-Type', 'text/html')

		reply.code(self.statusCode)

		reply.send(self.data)
