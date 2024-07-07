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
Object.defineProperty(exports, "__esModule", { value: true });
exports.ArticleOrderSchema = exports.OrderSchema = exports.Order = exports.ArticleOrder = exports.Status = exports.Priority = void 0;
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const user_schema_1 = require("../../auth/schemas/user.schema");
var Priority;
(function (Priority) {
    Priority["HIGH"] = "Eleve";
    Priority["MEDIUM"] = "Moyenne";
    Priority["LOW"] = "Faible";
})(Priority || (exports.Priority = Priority = {}));
var Status;
(function (Status) {
    Status["SEND"] = "Termine";
    Status["PROGRESS"] = "En cours";
})(Status || (exports.Status = Status = {}));
let ArticleOrder = class ArticleOrder {
};
exports.ArticleOrder = ArticleOrder;
__decorate([
    (0, mongoose_1.Prop)({ type: mongoose_2.default.Schema.Types.ObjectId, ref: 'Article', required: true }),
    __metadata("design:type", mongoose_2.default.Schema.Types.ObjectId)
], ArticleOrder.prototype, "article", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", Number)
], ArticleOrder.prototype, "quantity", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], ArticleOrder.prototype, "unit", void 0);
exports.ArticleOrder = ArticleOrder = __decorate([
    (0, mongoose_1.Schema)()
], ArticleOrder);
let Order = class Order {
};
exports.Order = Order;
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], Order.prototype, "dateCommande", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], Order.prototype, "dateLivraison", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], Order.prototype, "etatCommande", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], Order.prototype, "priority", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: mongoose_2.default.Schema.Types.ObjectId, ref: 'User', required: true }),
    __metadata("design:type", user_schema_1.User)
], Order.prototype, "user", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], Order.prototype, "client", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: mongoose_2.default.Schema.Types.ObjectId, ref: 'Site', required: true }),
    __metadata("design:type", mongoose_2.default.Schema.Types.ObjectId)
], Order.prototype, "site", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: [ArticleOrder], required: true }),
    __metadata("design:type", Array)
], Order.prototype, "articles", void 0);
__decorate([
    (0, mongoose_1.Prop)(),
    __metadata("design:type", String)
], Order.prototype, "observation", void 0);
exports.Order = Order = __decorate([
    (0, mongoose_1.Schema)()
], Order);
exports.OrderSchema = mongoose_1.SchemaFactory.createForClass(Order);
exports.ArticleOrderSchema = mongoose_1.SchemaFactory.createForClass(ArticleOrder);
//# sourceMappingURL=order.schema.js.map