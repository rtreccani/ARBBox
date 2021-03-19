typedef enum {
	CACHE_DIRTY,
	CACHE_CLEAN,
	REQUEST_SENT
} prefetch_state_t;

typedef enum {
	ONESHOT = 2'b01,
	REPEAT_N = 2'b10,
	REPEAT_INF = 2'b11
} playMode_t;

typedef enum {
	IDLE,
	DISCONNECTED,
	LOADLEN_AWAIT,
	LOAD,
	SETTING_AWAIT,
	PLAYBACK_PRELOAD,
	PLAYBACK
} state_t;

enum {
	PLAYMODE
} settingMap_t;