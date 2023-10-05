/**
@param {Error} error
@param {FormRequest} request
@param {FastifyReply} reply
*/
export function sendError(error: Error, request: FormRequest, reply: FastifyReply): HtmlResponse;
import { FormRequest } from "@formidablejs/framework";
import { FastifyReply } from "@formidablejs/framework";
import { HtmlResponse } from "./HtmlResponse";
