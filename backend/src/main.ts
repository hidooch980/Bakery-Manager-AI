import { ValidationPipe } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { RolesGuard } from './auth/roles/roles.guard';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalGuards(new RolesGuard(app.get(Reflector)));

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );
  app.enableCors();
  await app.listen(3000, '0.0.0.0');
}
bootstrap();
