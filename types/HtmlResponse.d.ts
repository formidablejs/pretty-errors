/// <reference types="node" />
export class HtmlResponse extends Response {
    /**
    @param {FastifyReply} reply
    */
    toResponse(reply: FastifyReply): FastifyReply<import("http").Server, import("http").IncomingMessage, import("http").ServerResponse, import("fastify/types/route").RouteGenericInterface, any>;
}
import { Response } from "@formidablejs/framework";
import { FastifyReply } from "@formidablejs/framework";
