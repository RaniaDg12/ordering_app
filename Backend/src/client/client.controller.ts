import { Body, Controller, Get, Logger, Param, Post } from '@nestjs/common';
import { ClientService } from './client.service';
import { Client, ClientDocument } from './schemas/client.schema';
import { CreateClientDto } from './dto/create-client.dto';

@Controller('clients')
export class ClientController {

    private readonly logger = new Logger(ClientController.name);
  
    constructor(private readonly clientService: ClientService) {}
    
    @Post()
    async create(@Body() CreateClientDto: CreateClientDto): Promise<Client> {
        return this.clientService.create(CreateClientDto);
    }

    @Get()
    async findAll(): Promise<Client[]> {
        return this.clientService.findAll();
    }

    @Get(':name')
    async findOne(@Param('name') name: string): Promise<any> {
      return this.clientService.findByName(name);
    }
}
