
#Create secret for MongoDB password
kubectl create secret generic bookinfo-dev-ratings-mongodb-secret \
  --from-literal=mongodb-password=CHANGEME \
  --from-literal=mongodb-root-password=CHANGEME

# Create configmap
cd ratings
kubectl create configmap bookinfo-dev-ratings-mongodb-initdb \
  --from-file=databases/ratings_data.json \
  --from-file=databases/script.sh

# Check config map
kubectl get configmap
kubectl describe configmap bookinfo-dev-ratings-mongodb-initdb

# Deploy new MongoDB with Helm Value
helm install -f k8s/helm-values/values-bookinfo-dev-ratings-mongodb.yaml \
  bookinfo-dev-ratings-mongodb bitnami/mongodb --version 10.28.4

#Run and test
kubectl apply -f k8s/