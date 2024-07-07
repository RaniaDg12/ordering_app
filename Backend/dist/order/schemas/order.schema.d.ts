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
    PROGRESS = "En cours"
}
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
    client: string;
    site: mongoose.Schema.Types.ObjectId;
    articles: ArticleOrder[];
    observation: string;
}
export declare const OrderSchema: mongoose.Schema<Order, mongoose.Model<Order, any, any, any, mongoose.Document<unknown, any, Order> & Order & {
    _id: mongoose.Types.ObjectId;
}, any>, {}, {}, {}, {}, mongoose.DefaultSchemaOptions, Order, mongoose.Document<unknown, {}, mongoose.FlatRecord<Order>> & mongoose.FlatRecord<Order> & {
    _id: mongoose.Types.ObjectId;
}>;
export declare const ArticleOrderSchema: mongoose.Schema<ArticleOrder, mongoose.Model<ArticleOrder, any, any, any, mongoose.Document<unknown, any, ArticleOrder> & ArticleOrder & {
    _id: mongoose.Types.ObjectId;
}, any>, {}, {}, {}, {}, mongoose.DefaultSchemaOptions, ArticleOrder, mongoose.Document<unknown, {}, mongoose.FlatRecord<ArticleOrder>> & mongoose.FlatRecord<ArticleOrder> & {
    _id: mongoose.Types.ObjectId;
}>;
