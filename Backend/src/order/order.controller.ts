import { Controller, Get, Post, Body, Patch, Param, Delete, Req, UseGuards, UnauthorizedException, Logger } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { OrderService } from './order.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { Order } from './schemas/order.schema';

@Controller('orders')
export class OrderController {
  private readonly logger = new Logger(OrderController.name);
  
  constructor(private readonly orderService: OrderService) {}

  @UseGuards(AuthGuard('jwt'))
  @Post()
  async create(@Body() createOrderDto: CreateOrderDto, @Req() req): Promise<Order> {
    const userId = req.user.userId;
    return this.orderService.create(createOrderDto, userId);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get()
  async findAll(@Req() req): Promise<Order[]> {
    this.logger.debug(`User in request: ${req.user}`);

    if (!req.user || !req.user.userId) {
      throw new UnauthorizedException('User not authenticated');
    }

    const userId = req.user.userId;
    return this.orderService.findAll(userId);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get(':id')
  async findOne(@Param('id') id: string): Promise<Order> {
    return this.orderService.findOne(id);
  }

  @UseGuards(AuthGuard('jwt'))
  @Patch(':id')
  async update(@Param('id') id: string, @Body() updateOrderDto: UpdateOrderDto): Promise<Order> {
    return this.orderService.update(id, updateOrderDto);
  }

  @UseGuards(AuthGuard('jwt'))
  @Delete(':id')
  async remove(@Param('id') id: string): Promise<Order> {
    return this.orderService.remove(id);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('status/:etatCommande')
  async findByEtatCommande(@Param('etatCommande') etatCommande: string, @Req() req): Promise<Order[]> {
    if (!req.user || !req.user.userId) {
      throw new UnauthorizedException('User not authenticated');
    }

    const userId = req.user.userId;
    return this.orderService.findByEtatCommande(etatCommande, userId).then(orders =>
      orders.filter(order => order.user.toString() === userId),
    ); 
  }
  
}

