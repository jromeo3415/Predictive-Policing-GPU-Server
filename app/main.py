from fastapi import FastAPI
import subprocess

app = FastAPI()
GPU_BUSY = False

def set_watchtower(enable: bool):
    label_value = "true" if enable else "false"
    subprocess.run([
        "docker", "update",
        f"--label-add=com.centurylinklabs.watchtower.enable={label_value}",
        "gpu-container"
    ])

@app.post("/start-job")
def start_job():
    global GPU_BUSY
    if GPU_BUSY:
        return {"status": "busy"}
    GPU_BUSY = True
    set_watchtower(False)
    return {"status": "job started"}

@app.post("/finish-job")
def finish_job():
    global GPU_BUSY
    GPU_BUSY = False
    set_watchtower(True)
    return {"status": "job finished"}

@app.get("/status")
def status():
    return {"gpu_busy": GPU_BUSY}
