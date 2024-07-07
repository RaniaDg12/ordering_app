"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
var OrderService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.OrderService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const jwt_1 = require("@nestjs/jwt");
const order_schema_1 = require("./schemas/order.schema");
let OrderService = OrderService_1 = class OrderService {
    constructor(orderModel, jwtService) {
        this.orderModel = orderModel;
        this.jwtService = jwtService;
        this.logger = new common_1.Logger(OrderService_1.name);
    }
    async create(createOrderDto, userId) {
        const { site, articles, ...rest } = createOrderDto;
        this.logger.debug(`Creating order with site: ${site} and articles: ${JSON.stringify(articles)}`);
        const foundSite = await this.orderModel.db.collection('sites').findOne({ name: site });
        if (!foundSite) {
            throw new common_1.NotFoundException(`Site with name ${site} not found`);
        }
        this.logger.debug(`Found site: ${JSON.stringify(foundSite)}`);
        const transformedArticles = await Promise.all(articles.map(async (articleOrder) => {
            const foundArticle = await this.orderModel.db.collection('articles').findOne({ name: articleOrder.article });
            if (!foundArticle) {
                throw new common_1.NotFoundException(`Article with name ${articleOrder.article} not found`);
            }
            this.logger.debug(`Found article: ${JSON.stringify(foundArticle)}`);
            return {
                ...articleOrder,
                article: foundArticle._id,
            };
        }));
        this.logger.debug(`Transformed articles: ${JSON.stringify(transformedArticles)}`);
        const order = new this.orderModel({
            ...rest,
            site: foundSite._id,
            articles: transformedArticles,
            user: userId,
        });
        this.logger.debug(`Final order object: ${JSON.stringify(order)}`);
        return order.save();
    }
    async findAll(userId) {
        return this.orderModel.find({ user: userId }).exec();
    }
    async findOne(id) {
        const order = await this.orderModel.findById(id).exec();
        if (!order) {
            throw new common_1.NotFoundException(`Order with ID ${id} not found`);
        }
        return order;
    }
    async update(id, updateOrderDto) {
        const existingOrder = await this.orderModel.findByIdAndUpdate(id, updateOrderDto, { new: true }).exec();
        if (!existingOrder) {
            throw new common_1.NotFoundException(`Order with ID ${id} not found`);
        }
        return existingOrder;
    }
    async remove(id) {
        const deletedOrder = await this.orderModel.findByIdAndDelete(id).exec();
        if (!deletedOrder) {
            throw new common_1.NotFoundException(`Order with ID ${id} not found`);
        }
        return deletedOrder;
    }
    async findByEtatCommande(etatCommande, userId) {
        return this.orderModel.find({ etatCommande, user: userId }).exec();
    }
};
exports.OrderService = OrderService;
exports.OrderService = OrderService = OrderService_1 = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)(order_schema_1.Order.name)),
    __metadata("design:paramtypes", [mongoose_2.Model,
        jwt_1.JwtService])
], OrderService);
//# sourceMappingURL=order.service.js.map