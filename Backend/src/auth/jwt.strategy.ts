import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { PassportStrategy } from '@nestjs/passport';
import { Model } from 'mongoose';
import { Strategy, ExtractJwt } from 'passport-jwt';
import { User} from './schemas/user.schema';
import { Admin} from './schemas/Admin.schema';



interface JwtPayload
{
    id:String;
}

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    @InjectModel(User.name) private userModel: Model<User>,
    @InjectModel(Admin.name) private adminModel: Model<User>,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: process.env.JWT_SECRET,
    });
  }

  async validate(payload: JwtPayload): Promise<{ userId: string; username: string }> {
    const { id } = payload;

    const user = await this.userModel.findById(id).exec();

    if (!user) {
      throw new UnauthorizedException('Unauthorized');
    }
    console.log('User validated:', user);

    return { userId: user._id.toString(), username: user.name };
  }

  async validateAdmin(payload: JwtPayload): Promise<{ adminId: string; adminname: string }> {
    const { id } = payload;

    const admin = await this.adminModel.findById(id).exec();

    if (!admin) {
      throw new UnauthorizedException('Unauthorized');
    }
    console.log('admin validated:', admin);

    return { adminId: admin._id.toString(), adminname: admin.name };
  }
}