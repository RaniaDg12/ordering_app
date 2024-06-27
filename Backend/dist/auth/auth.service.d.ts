import { Model } from 'mongoose';
import { User } from './schemas/user.schema';
import { JwtService } from '@nestjs/jwt';
import { SigninDto } from './dto/signin.dto';
export declare class AuthService {
    private userModel;
    private jwtService;
    private readonly logger;
    constructor(userModel: Model<User>, jwtService: JwtService);
    signin(signinDto: SigninDto): Promise<{
        token: string;
    }>;
}
