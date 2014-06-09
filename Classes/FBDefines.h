#define NOTHING

/* Singletons */
#define SINGLETON_HEADER(classname) + (classname *)sharedController;
#define SINGLETON_BODY(classname)   + (classname *)sharedController { static classname *instance = nil; static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{ instance = [[classname alloc] init]; }); return instance; }

/* Semaphores */
#define TIMEOUT (5.0)
#define SemaphoreSetup(SEM_NAME) dispatch_semaphore_t SEM_NAME = dispatch_semaphore_create(0);

#define SemaphoreSignal(SEM_NAME) dispatch_semaphore_signal(SEM_NAME);

#define SemaphoreWait(SEM_NAME) \
while (dispatch_semaphore_wait(SEM_NAME, DISPATCH_TIME_NOW)) { \
[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode \
beforeDate:[NSDate dateWithTimeIntervalSinceNow:TIMEOUT]]; }
