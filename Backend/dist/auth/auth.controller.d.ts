import { AuthService } from './auth.service';
export declare class AuthController {
    private authService;
    private readonly logger;
    constructor(authService: AuthService);
    signin(name: string, password: string): Promise<{
        token: string;
    }>;
}
