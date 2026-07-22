import { IsString, IsNumber, IsOptional, IsUUID, Min } from 'class-validator';

export class CreateInventoryDto {
  @IsString()
  name: string;

  @IsString()
  unit: string;

  @IsNumber()
  @Min(0)
  quantity: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  minStock?: number;

  @IsOptional()
  @IsUUID()
  branchId?: string;
}
