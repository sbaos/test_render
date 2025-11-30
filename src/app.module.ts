import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersModule } from './users/users.module';
import { User } from './users/user.entity';
import { AppController } from './app.controller';
import { AppService } from './app.service';

@Module({
  imports: [
    UsersModule,
    TypeOrmModule.forRoot({
      type: 'postgres',
      url: process.env.DATABASE_URL,
      entities: [User],
      synchronize: true, 
      ssl: { rejectUnauthorized: false }, // nếu DB online yêu cầu SSL (heroku, cloud)
    }),
    TypeOrmModule.forFeature([User]), // inject repository in UsersModule
  ],
  controllers: [AppController],
  providers: [AppService]
})
export class AppModule {}
