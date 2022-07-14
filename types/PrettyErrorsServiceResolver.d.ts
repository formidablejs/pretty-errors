export default class PrettyErrorsServiceResolver extends ServiceResolver {
    boot(): import("@formidablejs/framework").Application;
    modifyHeaders(response: any, request: any, reply: any): any;
    /**
    @param {Error} response
    @param {FormRequest} request
    @param {FastifyReply} reply
    */
    errorHandler(response: Error, request: FormRequest, reply: FastifyReply): boolean | Promise<boolean>;
    /**
    @param {Error} response
    @param {FormRequest} request
    @param {FastifyReply} reply
    */
    handleProductionErrors(response: Error, request: FormRequest, reply: FastifyReply): boolean;
    /**
    @param {Error} response
    @param {FormRequest} request
    @param {FastifyReply} reply
    */
    handleDevelopmentErrors(response: Error, request: FormRequest, reply: FastifyReply): Promise<boolean>;
}
import { ServiceResolver } from "@formidablejs/framework";
import { FormRequest } from "@formidablejs/framework";
import { FastifyReply } from "@formidablejs/framework";
