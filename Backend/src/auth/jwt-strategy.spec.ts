import { UnauthorizedException } from '@nestjs/common';
import { JwtStrategy } from './jwt.strategy';
import { User } from './schemas/user.schema';
import { getModelToken } from '@nestjs/mongoose';
import { Test, TestingModule } from '@nestjs/testing';
import { Model } from 'mongoose';

describe('JwtStrategy', () => {
  let jwtStrategy: JwtStrategy;
  let userModel: Model<User>;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        JwtStrategy,
        {
          provide: getModelToken(User.name),
          useValue: {
            findById: jest.fn(),
          },
        },
      ],
    }).compile();

    jwtStrategy = module.get<JwtStrategy>(JwtStrategy);
    userModel = module.get<Model<User>>(getModelToken(User.name));
  });

  it('should validate and return user details', async () => {
    const userId = '60d...abc';
    const user = { _id: userId, name: 'John Doe' };

    jest.spyOn(userModel, 'findById').mockResolvedValue(user as any);

    const result = await jwtStrategy.validate({ id: userId });

    expect(result).toEqual({ userId: userId, username: 'John Doe' });
  });

  it('should throw unauthorized exception if user not found', async () => {
    jest.spyOn(userModel, 'findById').mockResolvedValue(null);

    await expect(jwtStrategy.validate({ id: 'invalid-id' })).rejects.toThrow(UnauthorizedException);
  });
});
