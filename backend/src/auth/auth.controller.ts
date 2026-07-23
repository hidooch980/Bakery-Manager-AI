import { Body, Controller, Get, Post, Req } from '@nestjs/common';
import { AuthService } from './auth.service';
import { Public } from './public.decorator';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Public()
  @Post('login')
  login(@Body() data: { phone: string; password: string }) {
    return this.authService.login(data.phone, data.password);
  }

  /** تمدید توکن دسترسی با refresh token */
  @Public()
  @Post('refresh')
  refresh(@Body() data: { refresh_token: string }) {
    return this.authService.refresh(data.refresh_token);
  }

  /** خروج و باطل کردن refresh token */
  @Public()
  @Post('logout')
  logout(@Body() data: { refresh_token?: string }) {
    return this.authService.logout(data?.refresh_token || '');
  }

  /** اطلاعات کاربر جاری */
  @Get('me')
  me(@Req() req: { user: { id: string } }) {
    return this.authService.me(req.user.id);
  }
}
