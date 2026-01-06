#!/usr/bin/env python3
"""Bot main entry point with aiogram."""

import os
import asyncio
import aiohttp
from aiogram import Bot, Dispatcher, types
from aiogram.filters import Command

# Environment variables
TELEGRAM_BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN", "")
CORE_API_URL = os.getenv("CORE_BASE_URL", "http://core:8000")

# Initialize bot and dispatcher
bot = Bot(token=TELEGRAM_BOT_TOKEN) if TELEGRAM_BOT_TOKEN else None
dp = Dispatcher()


async def check_core_health() -> bool:
    """Check if core API is healthy."""
    try:
        async with aiohttp.ClientSession() as session:
            async with session.get(f"{CORE_API_URL}/health", timeout=aiohttp.ClientTimeout(total=5)) as response:
                return response.status == 200
    except Exception:
        return False


@dp.message(Command("start"))
async def cmd_start(message: types.Message):
    """Handle /start command."""
    core_status = "ok" if await check_core_health() else "нет"
    await message.answer(f"бот жив, core {core_status}")


@dp.message(Command("health"))
async def cmd_health(message: types.Message):
    """Handle /health command - check core API health."""
    try:
        async with aiohttp.ClientSession() as session:
            async with session.get(f"{CORE_API_URL}/health", timeout=aiohttp.ClientTimeout(total=5)) as response:
                if response.status == 200:
                    text = await response.text()
                    await message.answer(f"Core API health: OK\n{text}")
                else:
                    await message.answer(f"Core API health: FAILED (status {response.status})")
    except Exception as e:
        await message.answer(f"Core API health: ERROR\n{str(e)}")


async def main():
    """Main bot function."""
    print(f"BOT: CORE_API_URL={CORE_API_URL}")
    
    if not TELEGRAM_BOT_TOKEN:
        print("BOT: TELEGRAM_BOT_TOKEN is not set, running idle mode")
        # Idle mode: sleep forever
        while True:
            await asyncio.sleep(60)
    else:
        print("BOT: Starting aiogram bot...")
        try:
            # Start polling
            await dp.start_polling(bot)
        except Exception as e:
            print(f"BOT: Error starting bot: {e}")
            # Fallback to idle
            while True:
                await asyncio.sleep(60)


if __name__ == "__main__":
    asyncio.run(main())
