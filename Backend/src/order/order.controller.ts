import { Controller, Get, Post, Body, Patch, Param, Delete, Req, UseGuards, UnauthorizedException, Logger, Put } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { OrderService } from './order.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { Order } from './schemas/order.schema';

@Controller('orders')
export class OrderController {
  private readonly logger = new Logger(OrderController.name);
  
  constructor(private readonly orderService: OrderService) {}

  @Get('all')
  async findAllOrders(): Promise<Order[]> {
    return this.orderService.findAllOrders();
  }
  
  @Put('update/:id')
  async update(@Param('id') id: string, @Body() updateOrderDto: UpdateOrderDto): Promise<Order> {
    return this.orderService.update(id, updateOrderDto);
  }

  
  @Delete('delete/:id')
  async remove(@Param('id') id: string): Promise<Order> {
    return this.orderService.remove(id);
  }
  
  @Get('count/all')
  async countAll() {
    return this.orderService.countAll();
  }

  @Get('sites/count/:site')
  async countBySiteName(@Param('site') site: string) {
    return this.orderService.countBySiteName(site);
  }

  @Get('users/count/:user')
  async countByUserName(@Param('user') user: string) {
    return this.orderService.countByUserName(user);
  }

  @Get('dates/count/:datecommande')
  async countByDateCommande(@Param('datecommande') dateCommande: string) {
    console.log('Received dateCommande:', dateCommande); // Log received parameter
    return this.orderService.countByDateCommande(dateCommande);
  }


  @Get('dates/count')
  async countByDateRange() {
    return this.orderService.countByDateRange();
  }





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
  async findOne(@Param('id') id: string, @Req() req): Promise<any> {
    const userId = req.user.userId;
    return this.orderService.findOne(id, userId);
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

