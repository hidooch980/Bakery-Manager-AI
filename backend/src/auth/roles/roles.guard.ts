import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  UnauthorizedException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import * as jwt from 'jsonwebtoken';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const roles = this.reflector.get<string[]>('roles', context.getHandler());

    if (!roles || roles.length === 0) return true;

    const request = context.switchToHttp().getRequest();
    const authHeader = request.headers?.authorization || request.headers?.Authorization;

    if (!authHeader || typeof authHeader !== 'string') {
      throw new UnauthorizedException('Authorization token required');
    }

    const [scheme, token] = authHeader.split(' ');
    if (scheme?.toLowerCase() !== 'bearer' || !token) {
      throw new UnauthorizedException('Invalid authorization header');
    }

    try {
      const payload = jwt.verify(
        token,
        process.env.JWT_SECRET || 'bakery-manager-secret',
      ) as { role?: string; sub?: string };

      request.user = payload;

      if (payload.role === 'ADMIN' || roles.includes(payload.role || '')) {
        return true;
      }
    } catch (_) {
      throw new UnauthorizedException('Invalid or expired token');
    }

    throw new ForbiddenException('Access denied');
  }
}
