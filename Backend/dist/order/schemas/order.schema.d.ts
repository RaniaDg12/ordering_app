import mongoose, { Document } from 'mongoose';
import { User } from 'src/auth/schemas/user.schema';
export type OrderDocument = Order & Document;
export declare enum Priority {
    HIGH = "Eleve",
    MEDIUM = "Moyenne",
    LOW = "Faible"
}
export declare enum Status {
    SEND = "Termine",
    PROGRESS = "Encours"
}
export declare class Site {
    name: string;
}
export declare const SiteSchema: mongoose.Schema<Site, mongoose.Model<Site, any, any, any, mongoose.Document<unknown, any, Site> & Site & {
    _id: mongoose.Types.ObjectId;
}, any>, {}, {}, {}, {}, mongoose.DefaultSchemaOptions, Site, mongoose.Document<unknown, {}, mongoose.FlatRecord<Site>> & mongoose.FlatRecord<Site> & {
    _id: mongoose.Types.ObjectId;
}>;
export declare class Client {
    name: string;
}
export declare const ClientSchema: mongoose.Schema<Site, mongoose.Model<Site, any, any, any, mongoose.Document<unknown, any, Site> & Site & {
    _id: mongoose.Types.ObjectId;
}, any>, {}, {}, {}, {}, mongoose.DefaultSchemaOptions, Site, mongoose.Document<unknown, {}, mongoose.FlatRecord<Site>> & mongoose.FlatRecord<Site> & {
    _id: mongoose.Types.ObjectId;
}>;
export declare class Article extends Document {
    name: string;
}
export declare const ArticleSchema: mongoose.Schema<Article, mongoose.Model<Article, any, any, any, mongoose.Document<unknown, any, Article> & Article & Required<{
    _id: unknown;
}>, any>, {}, {}, {}, {}, mongoose.DefaultSchemaOptions, Article, mongoose.Document<unknown, {}, mongoose.FlatRecord<Article>> & mongoose.FlatRecord<Article> & Required<{
    _id: unknown;
}>>;
export declare class ArticleOrder {
    article: mongoose.Schema.Types.ObjectId;
    quantity: number;
    unit: string;
}
export declare class Order {
    dateCommande: string;
    dateLivraison: string;
    etatCommande: Status;
    priority: Priority;
    user: User;
    client: mongoose.Schema.Types.ObjectId;
    site: mongoose.Schema.Types.ObjectId;
    articles: ArticleOrder[];
    observation: string;
}
export declare const ArticleOrderSchema: mongoose.Schema<ArticleOrder, mongoose.Model<ArticleOrder, any, any, any, mongoose.Document<unknown, any, ArticleOrder> & ArticleOrder & {
    _id: mongoose.Types.ObjectId;
}, any>, {}, {}, {}, {}, mongoose.DefaultSchemaOptions, ArticleOrder, mongoose.Document<unknown, {}, mongoose.FlatRecord<ArticleOrder>> & mongoose.FlatRecord<ArticleOrder> & {
    _id: mongoose.Types.ObjectId;
}>;
export declare const OrderSchema: mongoose.Schema<Order, mongoose.Model<Order, any, any, any, mongoose.Document<unknown, any, Order> & Order & {
    _id: mongoose.Types.ObjectId;
}, any>, {}, {}, {}, {}, mongoose.DefaultSchemaOptions, Order, mongoose.Document<unknown, {}, mongoose.FlatRecord<Order>> & mongoose.FlatRecord<Order> & {
    _id: mongoose.Types.ObjectId;
}>;
