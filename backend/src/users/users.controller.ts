import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
} from '@nestjs/common';
import { Roles } from '../auth/roles/roles.decorator';
import { UsersService } from './users.service';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  @Roles('MANAGER')
  findAll() {
    return this.usersService.findAll();
  }

  @Get(':id')
  @Roles('MANAGER')
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(id);
  }

  @Post()
  @Roles('MANAGER')
  create(
    @Body()
    data: {
      name: string;
      phone: string;
      password: string;
      role?: string;
    },
  ) {
    return this.usersService.create(data);
  }

  @Patch(':id')
  @Roles('MANAGER')
  update(
    @Param('id') id: string,
    @Body() data: { name?: string; role?: string; password?: string },
  ) {
    return this.usersService.update(id, data);
  }

  @Delete(':id')
  @Roles('MANAGER')
  remove(@Param('id') id: string) {
    return this.usersService.remove(id);
  }
}
