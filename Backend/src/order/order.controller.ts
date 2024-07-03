import { Controller, Get, Post, Body, Patch, Param, Delete, Query, Req, UseGuards, NotFoundException } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { OrderService } from './order.service';
import { Query as ExpressQuery } from 'express-serve-static-core';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { Order } from './schemas/order.schema';
import { User } from 'src/auth/schemas/user.schema';

@Controller('orders')
export class OrderController {
  constructor(private readonly orderService: OrderService) {}

  @UseGuards(AuthGuard('jwt'))
  @Post()
  async create(@Body() createOrderDto: CreateOrderDto, @Req() req): Promise<Order> {
    const userId = req.user.userId;
    return this.orderService.create(createOrderDto, userId);
  }

  
  @Get()
  findAll(@Query() query: ExpressQuery): Promise<Order[]> {
    return this.orderService.findAll(query);
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<Order> {
    return this.orderService.findOne(id);
  }

  @Patch(':id')
  async update(@Param('id') id: string, @Body() updateOrderDto: UpdateOrderDto): Promise<Order> {
    return this.orderService.update(id, updateOrderDto);
  }

  @Delete(':id')
  async remove(@Param('id') id: string): Promise<Order> {
    return this.orderService.remove(id);
  }

  @Get('/client/:clientId')
  async findByClient(@Param('clientId') clientId: string): Promise<Order[]> {
    return this.orderService.findByClient(clientId);
  }

  @Get('/status/:etatCommande')
  async findByEtatCommande(@Param('etatCommande') etatCommande: string): Promise<Order[]> {
    return this.orderService.findByEtatCommande(etatCommande);
  }
}
