#define WIN32_LEAN_AND_MEAN      // Exclude rarely-used stuff from Windows headers

#include <windows.h>


#include "hdr.h"
#include <iostream>
#include "WinUser.h"
#include <stdio.h>
#include <winerror.h>
#include <wingdi.h>
#include <stdexcept>
#include <string> 
#include <cstdlib>

#include <stdint.h>
#include <cstdlib>
#include <cstring>
#include <conio.h>
#include <vector>

using namespace std;

static void  SetHDR(UINT32 uid, bool enabled)
{
	uint32_t pathCount, modeCount;

	uint8_t set[] = { 0x0A, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x14, 0x81, 0x00, 0x00,
					 0x00, 0x00, 0x00, 0x00, 0x04, 0x01, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00 };

	uint8_t request[] = { 0x09, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x7C, 0x6F, 0x00,
						 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x01, 0x00, 0x00, 0xDB, 0x00,
						 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00 };

	if (ERROR_SUCCESS == GetDisplayConfigBufferSizes(QDC_ONLY_ACTIVE_PATHS, &pathCount, &modeCount))
	{
		DISPLAYCONFIG_PATH_INFO* pathsArray = nullptr;
		DISPLAYCONFIG_MODE_INFO* modesArray = nullptr;

		const size_t sizePathsArray = pathCount * sizeof(DISPLAYCONFIG_PATH_INFO);
		const size_t sizeModesArray = modeCount * sizeof(DISPLAYCONFIG_MODE_INFO);

		pathsArray = static_cast<DISPLAYCONFIG_PATH_INFO*>(std::malloc(sizePathsArray));
		modesArray = static_cast<DISPLAYCONFIG_MODE_INFO*>(std::malloc(sizeModesArray));


		if (pathsArray != nullptr && modesArray != nullptr)
		{
			std::memset(pathsArray, 0, sizePathsArray);
			std::memset(modesArray, 0, sizeModesArray);

			LONG queryRet = QueryDisplayConfig(QDC_ONLY_ACTIVE_PATHS, &pathCount, pathsArray,
				&modeCount, modesArray, 0);
			if (ERROR_SUCCESS == queryRet)

			{



				DISPLAYCONFIG_GET_ADVANCED_COLOR_INFO getColorInfo = {};
				getColorInfo.header.type = DISPLAYCONFIG_DEVICE_INFO_GET_ADVANCED_COLOR_INFO;
				getColorInfo.header.size = sizeof(getColorInfo);

				DISPLAYCONFIG_SET_ADVANCED_COLOR_STATE setColorState = {};
				setColorState.header.type = DISPLAYCONFIG_DEVICE_INFO_SET_ADVANCED_COLOR_STATE;
				setColorState.header.size = sizeof(setColorState);


				for (int i = 0; i < modeCount; i++)
				{
					try
					{
						if (modesArray[i].id != uid)
							continue;
						if (modesArray[i].infoType == DISPLAYCONFIG_MODE_INFO_TYPE_TARGET)
						{
							DISPLAYCONFIG_MODE_INFO mode = modesArray[i];
							getColorInfo.header.adapterId.HighPart = mode.adapterId.HighPart;
							getColorInfo.header.adapterId.LowPart = mode.adapterId.LowPart;
							getColorInfo.header.id = mode.id;

							setColorState.header.adapterId.HighPart = mode.adapterId.HighPart;
							setColorState.header.adapterId.LowPart = mode.adapterId.LowPart;
							setColorState.header.id = mode.id;

							if (ERROR_SUCCESS == DisplayConfigGetDeviceInfo(&getColorInfo.header))
							{
								UINT32 value = enabled == true ? 1 : 0;
								if (value != getColorInfo.advancedColorEnabled)
								{
									setColorState.enableAdvancedColor = enabled;
									DisplayConfigSetDeviceInfo(&setColorState.header);
									break;
								}
							}

						}
					}
					catch (const std::exception)
					{

					}
				}

			}

			std::free(pathsArray);
			std::free(modesArray);
		}
		else
		{
			throw std::invalid_argument("No monitor found.");
		}


	}
}

static void  SetGlobalHDR(bool enabled)
{
	uint32_t pathCount, modeCount;

	uint8_t set[] = { 0x0A, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x14, 0x81, 0x00, 0x00,
					 0x00, 0x00, 0x00, 0x00, 0x04, 0x01, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00 };

	uint8_t request[] = { 0x09, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x7C, 0x6F, 0x00,
						 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x01, 0x00, 0x00, 0xDB, 0x00,
						 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00 };

	if (ERROR_SUCCESS == GetDisplayConfigBufferSizes(QDC_ONLY_ACTIVE_PATHS, &pathCount, &modeCount))
	{
		DISPLAYCONFIG_PATH_INFO* pathsArray = nullptr;
		DISPLAYCONFIG_MODE_INFO* modesArray = nullptr;

		const size_t sizePathsArray = pathCount * sizeof(DISPLAYCONFIG_PATH_INFO);
		const size_t sizeModesArray = modeCount * sizeof(DISPLAYCONFIG_MODE_INFO);

		pathsArray = static_cast<DISPLAYCONFIG_PATH_INFO*>(std::malloc(sizePathsArray));
		modesArray = static_cast<DISPLAYCONFIG_MODE_INFO*>(std::malloc(sizeModesArray));


		if (pathsArray != nullptr && modesArray != nullptr)
		{
			std::memset(pathsArray, 0, sizePathsArray);
			std::memset(modesArray, 0, sizeModesArray);

			LONG queryRet = QueryDisplayConfig(QDC_ONLY_ACTIVE_PATHS, &pathCount, pathsArray,
				&modeCount, modesArray, 0);
			if (ERROR_SUCCESS == queryRet)
			{
				DISPLAYCONFIG_DEVICE_INFO_HEADER* setPacket =
					reinterpret_cast<DISPLAYCONFIG_DEVICE_INFO_HEADER*>(set);
				DISPLAYCONFIG_DEVICE_INFO_HEADER* requestPacket =
					reinterpret_cast<DISPLAYCONFIG_DEVICE_INFO_HEADER*>(request);

				for (int i = 0; i < modeCount; i++)
				{
					try
					{
						SetHDR(modesArray[i].id, enabled);
					}
					catch (const std::exception&)
					{

					}
				}
			}
			std::free(pathsArray);
			std::free(modesArray);
		}
		else
		{
			throw std::invalid_argument("No monitor found.");
		}
	}
}
static UINT32 _GetUID(UINT32 id)
{
	SIZE resolution = SIZE();
	UINT32 status = 1;

	uint32_t pathCount, modeCount;

	if (ERROR_SUCCESS == GetDisplayConfigBufferSizes(QDC_ONLY_ACTIVE_PATHS, &pathCount, &modeCount))
	{
		DISPLAYCONFIG_PATH_INFO* pathsArray = nullptr;
		DISPLAYCONFIG_MODE_INFO* modesArray = nullptr;

		const size_t sizePathsArray = pathCount * sizeof(DISPLAYCONFIG_PATH_INFO);
		const size_t sizeModesArray = modeCount * sizeof(DISPLAYCONFIG_MODE_INFO);

		pathsArray = static_cast<DISPLAYCONFIG_PATH_INFO*>(std::malloc(sizePathsArray));
		modesArray = static_cast<DISPLAYCONFIG_MODE_INFO*>(std::malloc(sizeModesArray));

		if (pathsArray != nullptr && modesArray != nullptr)
		{
			std::memset(pathsArray, 0, sizePathsArray);
			std::memset(modesArray, 0, sizeModesArray);

			if (ERROR_SUCCESS == QueryDisplayConfig(QDC_ONLY_ACTIVE_PATHS, &pathCount, pathsArray,
				&modeCount, modesArray, 0))
			{
				for (int i = 0; i < pathCount; i++)
				{
					try
					{
						if (pathsArray[i].sourceInfo.id == id)
						{
							return pathsArray[i].targetInfo.id;
						}
					}
					catch (const std::exception&)
					{

					}
				}
			}
			std::free(pathsArray);
			std::free(modesArray);
			status = 0;
		}
	}
	return status;
}


static UINT32 _GetColorDepth(UINT32 uid)
{

	uint32_t pathCount, modeCount;

	uint8_t request[] = { 0x09, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x7C, 0x6F, 0x00,
						 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x01, 0x00, 0x00, 0xDB, 0x00,
						 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00 };

	if (ERROR_SUCCESS == GetDisplayConfigBufferSizes(QDC_ONLY_ACTIVE_PATHS, &pathCount, &modeCount))
	{
		DISPLAYCONFIG_PATH_INFO* pathsArray = nullptr;
		DISPLAYCONFIG_MODE_INFO* modesArray = nullptr;

		const size_t sizePathsArray = pathCount * sizeof(DISPLAYCONFIG_PATH_INFO);
		const size_t sizeModesArray = modeCount * sizeof(DISPLAYCONFIG_MODE_INFO);

		pathsArray = static_cast<DISPLAYCONFIG_PATH_INFO*>(std::malloc(sizePathsArray));
		modesArray = static_cast<DISPLAYCONFIG_MODE_INFO*>(std::malloc(sizeModesArray));

		if (pathsArray != nullptr && modesArray != nullptr)
		{
			std::memset(pathsArray, 0, sizePathsArray);
			std::memset(modesArray, 0, sizeModesArray);

			if (ERROR_SUCCESS == QueryDisplayConfig(QDC_ONLY_ACTIVE_PATHS, &pathCount, pathsArray,
				&modeCount, modesArray, 0))
			{
				DISPLAYCONFIG_DEVICE_INFO_HEADER* requestPacket =
					reinterpret_cast<DISPLAYCONFIG_DEVICE_INFO_HEADER*>(request);

				for (int i = 0; i < modeCount; i++)
				{
					try
					{
						if (modesArray[i].infoType == DISPLAYCONFIG_MODE_INFO_TYPE_TARGET)
						{
							requestPacket->adapterId.HighPart = modesArray[i].adapterId.HighPart;
							requestPacket->adapterId.LowPart = modesArray[i].adapterId.LowPart;
							requestPacket->id = modesArray[i].id;
						}
						if (modesArray[i].id != uid)
							continue;
						if (ERROR_SUCCESS == DisplayConfigGetDeviceInfo(requestPacket))
						{
							UINT32 number = request[28];
							return number;
						}
					}
					catch (const std::exception&)
					{

					}

				}
			}
			std::free(pathsArray);
			std::free(modesArray);
		}
	}
	return 0;

}

static void _SetColorDepth(UINT32 uid, UINT32 colorDepth)
{
	uint32_t pathCount, modeCount;


	uint8_t set[] = { 0x0A, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x14, 0x81, 0x00,
					  0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x01, 0x00, 0x00, 0x01, 0x00,
					  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00 };

	uint8_t request[] = { 0x09, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x7C, 0x6F, 0x00,
						 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x01, 0x00, 0x00, 0xDB, 0x00,
						 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00 };

	if (ERROR_SUCCESS == GetDisplayConfigBufferSizes(QDC_ONLY_ACTIVE_PATHS, &pathCount, &modeCount))
	{
		DISPLAYCONFIG_PATH_INFO* pathsArray = nullptr;
		DISPLAYCONFIG_MODE_INFO* modesArray = nullptr;

		const size_t sizePathsArray = pathCount * sizeof(DISPLAYCONFIG_PATH_INFO);
		const size_t sizeModesArray = modeCount * sizeof(DISPLAYCONFIG_MODE_INFO);

		pathsArray = static_cast<DISPLAYCONFIG_PATH_INFO*>(std::malloc(sizePathsArray));
		modesArray = static_cast<DISPLAYCONFIG_MODE_INFO*>(std::malloc(sizeModesArray));


		if (pathsArray != nullptr && modesArray != nullptr)
		{
			std::memset(pathsArray, 0, sizePathsArray);
			std::memset(modesArray, 0, sizeModesArray);

			LONG queryRet = QueryDisplayConfig(QDC_ONLY_ACTIVE_PATHS, &pathCount, pathsArray,
				&modeCount, modesArray, 0);
			if (ERROR_SUCCESS == queryRet)
			{
				DISPLAYCONFIG_DEVICE_INFO_HEADER* setPacket =
					reinterpret_cast<DISPLAYCONFIG_DEVICE_INFO_HEADER*>(set);
				DISPLAYCONFIG_DEVICE_INFO_HEADER* requestPacket =
					reinterpret_cast<DISPLAYCONFIG_DEVICE_INFO_HEADER*>(request);

				for (int i = 0; i < modeCount; i++)
				{
					try
					{
						if (modesArray[i].id != uid)
							continue;

						if (modesArray[i].infoType == DISPLAYCONFIG_MODE_INFO_TYPE_TARGET)
						{
							setPacket->adapterId.HighPart = modesArray[i].adapterId.HighPart;
							setPacket->adapterId.LowPart = modesArray[i].adapterId.LowPart;
							setPacket->id = modesArray[i].id;

							requestPacket->adapterId.HighPart = modesArray[i].adapterId.HighPart;
							requestPacket->adapterId.LowPart = modesArray[i].adapterId.LowPart;
							requestPacket->id = modesArray[i].id;

							if (ERROR_SUCCESS == DisplayConfigGetDeviceInfo(requestPacket))
							{
								set[28] = colorDepth;
								DisplayConfigSetDeviceInfo(setPacket);
							}

						}
					}
					catch (const std::exception&)
					{
					}
				}
			}
			std::free(pathsArray);
			std::free(modesArray);
		}
		else
		{
			throw std::invalid_argument("No monitor found.");
		}
	}
}

static bool HDRIsOn(UINT32 uid)
{
	uint32_t pathCount, modeCount;

	uint8_t set[] = { 0x0A, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x14, 0x81, 0x00, 0x00,
					 0x00, 0x00, 0x00, 0x00, 0x04, 0x01, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00 };

	uint8_t request[] = { 0x09, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x7C, 0x6F, 0x00,
						 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x01, 0x00, 0x00, 0xDB, 0x00,
						 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00 };

	if (ERROR_SUCCESS == GetDisplayConfigBufferSizes(QDC_ONLY_ACTIVE_PATHS, &pathCount, &modeCount))
	{
		DISPLAYCONFIG_PATH_INFO* pathsArray = nullptr;
		DISPLAYCONFIG_MODE_INFO* modesArray = nullptr;

		const size_t sizePathsArray = pathCount * sizeof(DISPLAYCONFIG_PATH_INFO);
		const size_t sizeModesArray = modeCount * sizeof(DISPLAYCONFIG_MODE_INFO);

		pathsArray = static_cast<DISPLAYCONFIG_PATH_INFO*>(std::malloc(sizePathsArray));
		modesArray = static_cast<DISPLAYCONFIG_MODE_INFO*>(std::malloc(sizeModesArray));


		if (pathsArray != nullptr && modesArray != nullptr)
		{
			std::memset(pathsArray, 0, sizePathsArray);
			std::memset(modesArray, 0, sizeModesArray);

			LONG queryRet = QueryDisplayConfig(QDC_ONLY_ACTIVE_PATHS, &pathCount, pathsArray,
				&modeCount, modesArray, 0);
			if (ERROR_SUCCESS == queryRet)

			{



				DISPLAYCONFIG_GET_ADVANCED_COLOR_INFO getColorInfo = {};
				getColorInfo.header.type = DISPLAYCONFIG_DEVICE_INFO_GET_ADVANCED_COLOR_INFO;
				getColorInfo.header.size = sizeof(getColorInfo);

				DISPLAYCONFIG_SET_ADVANCED_COLOR_STATE setColorState = {};
				setColorState.header.type = DISPLAYCONFIG_DEVICE_INFO_SET_ADVANCED_COLOR_STATE;
				setColorState.header.size = sizeof(setColorState);


				for (int i = 0; i < modeCount; i++)
				{
					try
					{
						if (modesArray[i].id != uid)
							continue;
						if (modesArray[i].infoType == DISPLAYCONFIG_MODE_INFO_TYPE_TARGET)
						{
							DISPLAYCONFIG_MODE_INFO mode = modesArray[i];
							getColorInfo.header.adapterId.HighPart = mode.adapterId.HighPart;
							getColorInfo.header.adapterId.LowPart = mode.adapterId.LowPart;
							getColorInfo.header.id = mode.id;

							setColorState.header.adapterId.HighPart = mode.adapterId.HighPart;
							setColorState.header.adapterId.LowPart = mode.adapterId.LowPart;
							setColorState.header.id = mode.id;

							if (ERROR_SUCCESS == DisplayConfigGetDeviceInfo(&getColorInfo.header))
							{

								return getColorInfo.advancedColorSupported == 1 && getColorInfo.advancedColorEnabled == 1;
							}

						}
					}
					catch (const std::exception)
					{

					}
				}

			}

			std::free(pathsArray);
			std::free(modesArray);
		}
		else
		{
			throw std::invalid_argument("No monitor found.");
		}
	}
	return false;
}


static bool HDRIsOn()
{
	bool returnValue = false;

	uint32_t pathCount, modeCount;

	uint8_t set[] = { 0x0A, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x14, 0x81, 0x00, 0x00,
					 0x00, 0x00, 0x00, 0x00, 0x04, 0x01, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00 };

	uint8_t request[] = { 0x09, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x7C, 0x6F, 0x00,
						 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x01, 0x00, 0x00, 0xDB, 0x00,
						 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00 };

	if (ERROR_SUCCESS == GetDisplayConfigBufferSizes(QDC_ONLY_ACTIVE_PATHS, &pathCount, &modeCount))
	{
		DISPLAYCONFIG_PATH_INFO* pathsArray = nullptr;
		DISPLAYCONFIG_MODE_INFO* modesArray = nullptr;

		const size_t sizePathsArray = pathCount * sizeof(DISPLAYCONFIG_PATH_INFO);
		const size_t sizeModesArray = modeCount * sizeof(DISPLAYCONFIG_MODE_INFO);

		pathsArray = static_cast<DISPLAYCONFIG_PATH_INFO*>(std::malloc(sizePathsArray));
		modesArray = static_cast<DISPLAYCONFIG_MODE_INFO*>(std::malloc(sizeModesArray));

		if (pathsArray != nullptr && modesArray != nullptr)
		{
			std::memset(pathsArray, 0, sizePathsArray);
			std::memset(modesArray, 0, sizeModesArray);

			if (ERROR_SUCCESS == QueryDisplayConfig(QDC_ONLY_ACTIVE_PATHS, &pathCount, pathsArray,
				&modeCount, modesArray, 0))
			{
				DISPLAYCONFIG_DEVICE_INFO_HEADER* setPacket =
					reinterpret_cast<DISPLAYCONFIG_DEVICE_INFO_HEADER*>(set);
				DISPLAYCONFIG_DEVICE_INFO_HEADER* requestPacket =
					reinterpret_cast<DISPLAYCONFIG_DEVICE_INFO_HEADER*>(request);

				//HDR is off
				returnValue = false;
				for (int i = 0; i < modeCount; i++)
				{
					try
					{
						returnValue = HDRIsOn(modesArray[i].id);
						if (returnValue)
							return returnValue;
					}
					catch (const std::exception&)
					{

					}

				}
			}
			std::free(pathsArray);
			std::free(modesArray);
		}
	}
	return returnValue;
}

int main(int argc, char* argv[])
{
	if(argc < 2)
	{
		cout << "Error: At least 1 argument is required." << endl;
	}
	else
	{
		if(!strcmp(argv[1], "-h") || !strcmp(argv[1], "--help"))
		{
			cout << "Usage: " << argv[0] << " [-h|--help] {on|off|status} [monitor_number]" << endl;
		}
		else
		{
			if(!strcmp(argv[1], "status"))
			{
				string state = "off";

				if(HDRIsOn(_GetUID(atoi(argv[2]))))
				{
					state = "on";
				}
				cout << state;
			}

			else if(!strcmp(argv[1], "on"))
			{
				if(argc > 2)
				{
					SetHDR(_GetUID(atoi(argv[2])), 1);
				}
				else
				{
					SetGlobalHDR(1);
				}
			}

			else if(!strcmp(argv[1], "off"))
			{
				if(argc > 2)
				{
					SetHDR(_GetUID(atoi(argv[2])), 0);
				}
				else
				{
					SetGlobalHDR(0);
				}
			}
		}
	}
}