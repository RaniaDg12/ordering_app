import { Priority } from '../schemas/order.schema';
declare class CreateArticleOrderDto {
    article: string;
    quantity: number;
    unit: string;
}
export declare class CreateOrderDto {
    dateCommande: string;
    dateLivraison: string;
    etatCommande: string;
    priority: Priority;
    client: string;
    site: string;
    articles: CreateArticleOrderDto[];
    observation?: string;
}
export {};
