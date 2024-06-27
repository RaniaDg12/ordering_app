import { Body, Controller, Get, Post , Logger, Query} from '@nestjs/common';
import { AuthService } from './auth.service';
import { SigninDto } from './dto/signin.dto';

@Controller('auth')
export class AuthController {
  private readonly logger = new Logger(AuthController.name);
  
  constructor(private authService: AuthService) {}


  @Get('/signin')
  signin(@Query('name') name: string, @Query('password') password: string): Promise<{ token: string }> {
    this.logger.debug(`Received signin request for user: ${name}`);
    const signinDto: SigninDto = { name, password };
    return this.authService.signin(signinDto);
  }
}