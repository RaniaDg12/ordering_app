import { Injectable, UnauthorizedException, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from './schemas/user.schema';

import * as bcrypt from 'bcryptjs';
import { JwtService } from '@nestjs/jwt';
import { SigninDto } from './dto/signin.dto';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    @InjectModel(User.name)
    private userModel: Model<User>,
    private jwtService: JwtService,
  ) {}



  async signin(signinDto: SigninDto): Promise<{ token: string }> {
    const { name, password } = signinDto;

    const user = await this.userModel.findOne({ name });

    if (!user) {
      this.logger.error('User not found');
      throw new UnauthorizedException('Invalid name or password');
    }

    const isPasswordMatched = String(password).trim() === String(user.password).trim();

    if (!isPasswordMatched) {
      this.logger.error('Password does not match');
      throw new UnauthorizedException('Invalid name or password');
    }

    const token = this.jwtService.sign({ id: user._id });

    return { token };
  }
}