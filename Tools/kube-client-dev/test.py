from kubernetes import client, config
from wcwidth import wcswidth

config.load_kube_config()
v1 = client.CoreV1Api()

def fmt(x, w, align='r'):
    x = str(x)
    l = wcswidth(x)
    s = w-l
    if s <= 0:
        return x
    if align == 'l':
        return x + ' '*s
    if align == 'c':
        sl = s//2
        sr = s - sl
        return ' '*sl + x + ' '*sr
    return ' '*s + x

def pnt(arg, data):
    for p in arg:
        print(getattr(p, data), end='\t  ')
    print("\n")

print("\n[+] Node info\n|      IP      |       Hostname")

ns_info = v1.list_node(watch=False)
for i in ns_info.items:
    pnt(i.status.addresses, "address")

print("\n[+] Pods info\n|      IP      |       Namespace      |                     Pod's Name                   |        ServiceAccount      |    Token Mount  ")
pod_list = v1.list_pod_for_all_namespaces(watch=False)


for i in pod_list.items:
    print("{} {} {} {} {}" .format(fmt(i.status.pod_ip,20,'l'), fmt(i.metadata.namespace,20,'l'), fmt(i.metadata.name,50,'l'), fmt(i.spec.service_account,30,'l'), fmt(i.spec.automount_service_account_token,50,'l')))
    print("|    Images    |", end=" ")
    pnt(i.spec.containers,"image")
    print(i.spec.containers)
