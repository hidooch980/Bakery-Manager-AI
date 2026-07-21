import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  register(@Body() data: { name: string; phone: string; password: string; role?: string }) {
    return this.authService.register(data);
  }

  @Post('login')
  login(@Body() data: { phone: string; password: string }) {
    return this.authService.login(data.phone, data.password);
  }
}
