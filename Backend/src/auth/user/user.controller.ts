import { Controller, Body, Get, Post, Logger, Put, Delete, Param } from '@nestjs/common';
import { UserService } from './user.service';
import { User } from '../schemas/user.schema';
import { CreateUserDto } from './dto/create_user.dto';
import { UpdateUserDto } from './dto/update-user.dto';

@Controller('users')
export class UserController {
    private readonly logger = new Logger(UserController.name);
  
  constructor(private userService: UserService) {}


    
  @Post()
  async createUser(@Body() CreateUserDto: CreateUserDto): Promise<User> {
      return this.userService.createUser(CreateUserDto);
  }

  @Get()
  async findAll(): Promise<User[]> {
      return this.userService.findAll();
  }

  @Get('count/all')
  async countAll() {
    return this.userService.countAll();
  }

  @Put('update/:id')
    async update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto): Promise<User> {
        const updatedUser: Partial<User> = { ...updateUserDto, _id: id };
        console.log('Received update request for ID:', id);
        console.log('Update data:', updateUserDto);
        return this.userService.update(updatedUser as User);
    }

    @Delete('delete/:id')
    async delete(@Param('id') id: string): Promise<User> {
      console.log('Received delete request for ID:', id);
      return this.userService.delete(id);
    }
}
