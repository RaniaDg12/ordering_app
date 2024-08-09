import { Injectable, UnauthorizedException, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import * as bcrypt from 'bcryptjs';
import { User } from '../schemas/user.schema';
import { CreateUserDto } from './dto/create_user.dto';

@Injectable()
export class UserService {

    private readonly logger = new Logger(UserService.name);

  constructor(
    @InjectModel(User.name) private userModel: Model<User>
  ) {}
    
  async createUser(createUserDto: CreateUserDto): Promise<User> {
    const { password, ...rest } = createUserDto;
    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = new this.userModel({
      ...rest,
      password: hashedPassword,
    });

    return newUser.save();
  }


async findAll(): Promise<User[]> {
    return this.userModel.find().exec();
}

async countAll(): Promise<number> {
  return this.userModel.countDocuments().exec();
}

async update(user: Partial<User>): Promise<User> {
    console.log('Updating user with data:', user);
    const updatedUser = await this.userModel.findByIdAndUpdate(user._id, user, { new: true });
    console.log('Updated user:', updatedUser);
    return updatedUser;
}

  

async delete(id: string): Promise<User> {
    console.log(`Deleting user with ID: ${id}`);
    const deletedUser = await this.userModel.findByIdAndDelete(id);
    console.log('Deleted user:', deletedUser);
    return deletedUser;
} 

}
