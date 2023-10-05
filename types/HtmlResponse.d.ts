/// <reference types="node" />
export class HtmlResponse extends Response {
    /**
    @param {FastifyReply} reply
    */
    toResponse(reply: FastifyReply): FastifyReply<import("http").Server, import("http").IncomingMessage, import("http").ServerResponse, import("fastify").RouteGenericInterface, any, import("fastify").FastifySchema, import("fastify").FastifyTypeProviderDefault, unknown>;
}
import { Response } from "@formidablejs/framework";
import { FastifyReply } from "@formidablejs/framework";
