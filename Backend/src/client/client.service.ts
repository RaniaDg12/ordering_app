import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Client, ClientDocument } from './schemas/client.schema';
import { CreateClientDto } from './dto/create-client.dto';

@Injectable()
export class ClientService {

    constructor(@InjectModel(Client.name) private clientModel: Model<ClientDocument>) {}

    async create(createclientDto: CreateClientDto): Promise<Client> {
        const client = new this.clientModel(createclientDto);
        return client.save();
    }
    
    async findAll(): Promise<Client[]> {
        return this.clientModel.find().exec();
    }

    async findByName(name: string): Promise<Client> {
        const client = await this.clientModel.findOne({ name });
        if (!client) {
          throw new NotFoundException(`client with name ${name} not found`);
        }
        return client;
    }
}
