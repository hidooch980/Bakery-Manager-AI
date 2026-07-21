import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const exists = await prisma.user.findFirst({
    where: { phone: '09000000000' },
  });

  if (exists) {
    console.log('Admin already exists');
    return;
  }

  const password = await bcrypt.hash('Admin@123', 10);

  const admin = await prisma.user.create({
    data: {
      name: 'Administrator',
      phone: '09000000000',
      password,
      role: 'MANAGER',
    },
  });

  console.log('Admin created:', admin.id);
}

main()
  .catch(console.error)
  .finally(async () => {
    await prisma.$disconnect();
  });
