## Doc simple
### Instalación basica de argocd
```yml
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
mas info [ArgoDocumen](https://argo-cd.readthedocs.io/en/stable/getting_started/)
### Instalación por Helm 
mas info [ArgoDocumen](https://artifacthub.io/packages/helm/argo/argo-cd?modal=install)
### config basicas
#### Port Forwarding - Reenvio de puertos
```yml
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
##### logue de argocd client - obtención de contraseña 
```yml
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
```yml
argocd login 127.0.0.1:8080    # o el puerto de su reenvio
*usuario: admin
*password: *****
```
#### Creación de app dentro del projecto por default de Argocd, se puede crear diferentes projectos, pero se tiene que reunificar y crear permisos, asi como dar accesos a grupos de recursos en el cluster como en el namespace.
#### el projecto por defecto se crea en la instalación de los componentes de Argocd y ya cuenta con roles y permisos.
```yml
argocd proj list
----------------
NAME     DESCRIPTION  DESTINATIONS                         SOURCES                                        CLUSTER-RESOURCE-WHITELIST  NAMESPACE-RESOURCE-BLACKLIST  SIGNATURE-KEYS  ORPHANED-RESOURCES
default               *,*                                  *                                              */*                         <none>                        <none>          disabled
vida                  *,vida                               url=https://github.com/nilofe/prueba-ms-1.git  */*                         <none>                        <none>          disabled
vida-01               https://kubernetes.default.svc,vida  https://github.com/nilofe/prueba-ms-1.git   
```
#### En los projectos se puede agregar destinos, namespace y url entre otras cosas para gestionarlo de manera independiente.
mas info [ArgoDocumen](https://argo-cd.readthedocs.io/en/latest/user-guide/projects/)
#### En estes casos de prueba usaremos el projecto por ```default```.
```yml
argocd app create prueba-ms --repo https://github.com/nilofe/prueba-ms-1.git --path /. --dest-namespace vida --dest-server https://kubernetes.default.svc --directory-recurse
```
#### usamos un ```path``` para indicarle a Argocd que nuestro manifiesto de kubernetes esta en esa ruta del repositorio, mas sin encambio si le mandamos el parametro ```--file``` Argocd lo aceptara como un archivo directo de configuracion de un projecto de Argocd.
#### y nos saldra el error por consiguiente.
```yml
argocd app create prueba-ms --repo https://github.com/nilofe/prueba-ms-1.git --file k8s.yml --dest-namespace vida --dest-server https://kubernetes.default.svc 
---------------
FATA[0000] rpc error: code = Unknown desc = error while validating and normalizing app: error getting application's project: application 'prueba-ms' in namespace 'vida' is not allowed to use project 'default'
```
#### Verificamos nuestra app creada y podemos activar la sincronizacion inmediata, tambien si lo queremos.
```yml
argocd app list
---------------
NAME              CLUSTER                         NAMESPACE  PROJECT  STATUS     HEALTH       SYNCPOLICY  CONDITIONS       REPO                                       PATH        TARGET
argocd/nonde      https://kubernetes.default.svc  deploy     default  Unknown    Progressing  <none>      ComparisonError  https://github.com/nilofe/test-cev.git     ./manifest  HEAD
argocd/prueba-ms  https://kubernetes.default.svc  vida       default  OutOfSync  Missing      <none>      <none>           https://github.com/nilofe/prueba-ms-1.git  ./
```
#### Tambien para mayor comodidad se puede visualizar por el portal, 
![](https://github.com/nilofe/smp/blob/main/wordpress-prac-1/Captura%20de%20pantalla%202024-04-12%20014809.png)
![](https://github.com/nilofe/smp/blob/main/wordpress-prac-1/Captura%20de%20pantalla%202024-04-12%20014830.png)
#### Esta en estado ```OutOfSync``` por que falta ajustar algunas configuracion como el registry y entre otra.
#### Esta es una corta documentación de lo inmeso que es.

