import { Injectable, UnauthorizedException, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from './schemas/user.schema';
import { Admin } from './schemas/admin.schema';


import * as bcrypt from 'bcryptjs';
import { JwtService } from '@nestjs/jwt';
import { SigninDto } from './dto/signin.dto';
import { AdminSigninDto} from './dto/admin_signin.dto';
import { AdminSignupDto } from './dto/admin_signup.dto';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    @InjectModel(User.name) private userModel: Model<User>,
    @InjectModel(Admin.name) private adminModel: Model<Admin>, 
    private jwtService: JwtService,
  ) {}


  async signin(signinDto: SigninDto): Promise<{ token: string }> {
    const { name, password } = signinDto;

    const user = await this.userModel.findOne({ name });
    this.logger.debug(`user: ${name}`);

    if (!user) {
      this.logger.error('User not found');
      throw new UnauthorizedException('Invalid name or password');
    }

    //const isPasswordMatched = String(password).trim() === String(user.password).trim();

    const isPasswordMatched = await bcrypt.compare(password, user.password);

    if (!isPasswordMatched) {
      this.logger.error('Password does not match');
      throw new UnauthorizedException('Invalid name or password');
    }

    const token = this.jwtService.sign({ id: user._id });
    this.logger.debug(`token: ${token}`);

    return { token };
  }


  async signupAdmin(signupDto: AdminSignupDto): Promise<{ token: string }> {
    const { name, email, password } = signupDto;
    const hashedPassword = await bcrypt.hash(password, 10);
    
    const newAdmin = new this.adminModel({ name, email, password: hashedPassword });
    await newAdmin.save();

    const token = this.jwtService.sign({ id: newAdmin._id });
    return { token };
  }


  async signinAdmin(signinDto: AdminSigninDto): Promise<{ token: string }> {
    const { email, password } = signinDto;
    const admin = await this.adminModel.findOne({ email });

    if (!admin) {
      this.logger.error('Admin not found');
      throw new UnauthorizedException('Invalid email or password');
    }

    const isPasswordMatched = await bcrypt.compare(password, admin.password);
    if (!isPasswordMatched) {
      this.logger.error('Password does not match');
      throw new UnauthorizedException('Invalid email or password');
    }

    const token = this.jwtService.sign({ id: admin._id });
    return { token };
  }

  async fetchAdminDetails(token: string): Promise<Admin> {
    const decoded: any = this.jwtService.decode(token);
    if (!decoded || !decoded.id) {
      throw new UnauthorizedException('Invalid token');
    }

    const admin = await this.adminModel.findById(decoded.id).exec();
    if (!admin) {
      throw new UnauthorizedException('Admin not found');
    }

    return admin;
  }
  
}