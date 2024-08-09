import { Body, Controller, Get, Post , Logger, Query, UnauthorizedException, Req} from '@nestjs/common';
import { AuthService } from './auth.service';
import { SigninDto } from './dto/signin.dto';
import { AdminSigninDto} from './dto/admin_signin.dto';
import { AdminSignupDto } from './dto/admin_signup.dto';

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



  @Post('admin/signup')
  async adminSignup(@Body() signupDto: AdminSignupDto) {
    return this.authService.signupAdmin(signupDto);
  }

  @Post('admin/signin')
  async adminSignin(@Body() signinDto: AdminSigninDto) {
    return this.authService.signinAdmin(signinDto);
  }

  @Get('admin/details')
  async fetchAdminDetails(@Req() req: Request): Promise<any> {
    // Cast the headers to a known type and access authorization
    const token = req.headers['authorization']?.toString().split(' ')[1];
    if (!token) {
      throw new UnauthorizedException('No token provided');
    }

    return this.authService.fetchAdminDetails(token);
  }
}