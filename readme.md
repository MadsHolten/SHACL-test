# SHACL TESTPROJEKT

# Opsætning
Kræver docker

1. Klon dette projekt
2. Kør kommando docker-compose up
    - Starter en Fuseki version 3.13.1 med den konfiguration der ligger i mappen jena-docker (modificeret stain/docker)
    - Opretter et in-momory datasæt med den konfiguration der er defineret i `test-ds-in-mem.ttl`
3. Send POST request til (http://localhost:3030/ds/upload)[http://localhost:3030/ds/upload] med filen `data.ttl.gz`
![doc1](doc1.jpg "Step 1")
4. Send POST request til (http://localhost:3030/ds/query)[http://localhost:3030/ds/query] med form data query =
```
SELECT ?subject ?predicate ?object
WHERE {
  ?subject ?predicate ?object
}
LIMIT 25
```
![doc2](doc2.jpg "Step 2")
5. Send POST request til (http://localhost:3030/ds/shacl)[http://localhost:3030/ds/shacl] med indholdet af `rules.ttl` i body og `Content-Type`-header = `text/turtle`
![doc3](doc3.jpg "Step 3.1")
Resultatet kan også returneres i JSON-LD
![doc4](doc4.jpg "Step 3.2")