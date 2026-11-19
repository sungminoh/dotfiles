---
paths:
  - "**/*.py"
---

# Python Patterns

## API response format

```python
from typing import Generic, TypeVar
from pydantic import BaseModel

T = TypeVar("T")

class PaginationMeta(BaseModel):
    total: int
    page: int
    limit: int

class ApiResponse(BaseModel, Generic[T]):
    success: bool
    data: T | None = None
    error: str | None = None
    meta: PaginationMeta | None = None
```

## Repository

```python
from abc import ABC, abstractmethod
from typing import Generic, TypeVar

T = TypeVar("T")
CreateDTO = TypeVar("CreateDTO")
UpdateDTO = TypeVar("UpdateDTO")

class Repository(ABC, Generic[T, CreateDTO, UpdateDTO]):
    @abstractmethod
    async def find_all(self, filters: dict | None = None) -> list[T]: ...

    @abstractmethod
    async def find_by_id(self, id: str) -> T | None: ...

    @abstractmethod
    async def create(self, data: CreateDTO) -> T: ...

    @abstractmethod
    async def update(self, id: str, data: UpdateDTO) -> T: ...

    @abstractmethod
    async def delete(self, id: str) -> None: ...
```

## Service layer

```python
from dataclasses import dataclass

@dataclass
class UserService:
    user_repo: UserRepository
    email_service: EmailService

    async def create_user(self, data: CreateUserDTO) -> User:
        user = await self.user_repo.create(data)
        await self.email_service.send_welcome(user.email)
        return user
```

## Dependency injection (FastAPI)

```python
from functools import lru_cache
from typing import Annotated
from fastapi import Depends

@lru_cache
def get_settings() -> Settings:
    return Settings()

def get_db(settings: Annotated[Settings, Depends(get_settings)]) -> Database:
    return Database(settings.database_url)

def get_user_service(db: Annotated[Database, Depends(get_db)]) -> UserService:
    return UserService(user_repo=UserRepository(db))
```

## Context managers

```python
from collections.abc import AsyncIterator, Iterator
from contextlib import asynccontextmanager, contextmanager

@contextmanager
def managed_resource() -> Iterator[Resource]:
    resource = acquire_resource()
    try:
        yield resource
    finally:
        resource.release()

@asynccontextmanager
async def async_db_session() -> AsyncIterator[Session]:
    session = Session()
    try:
        yield session
        await session.commit()
    except Exception:
        await session.rollback()
        raise
    finally:
        await session.close()
```
