# ARG usage in FROMs has to go up here in global

ARG embedpy_img=kxsys/embedpy:latest

####

FROM $embedpy_img AS embedpy

FROM embedpy AS ml1

COPY requirements.txt *.q  README.md LICENSE /opt/kx/ml1/
COPY fresh /opt/kx/ml1/fresh
COPY utils /opt/kx/ml1/utils

ARG VCS_REF=dev
ARG BUILD_DATE=dev

LABEL	org.label-schema.schema-version="0.1" \
	org.label-schema.name=jupyterq \
	org.label-schema.description="ML library for kdb+" \
	org.label-schema.vendor="Kx" \
	org.label-schema.license="Apache-2.0" \
	org.label-schema.url="https://code.kx.com/q/ml/toolkit/" \
	org.label-schema.version="${VERSION:-dev}" \
	org.label-schema.vcs-url="https://github.com/fionncarr/ml1.git" \
	org.label-schema.vcs-ref="$VCS_REF" \
	org.label-schema.build-date="$BUILD_DATE" \
	org.label-schema.docker.cmd="docker run kxsys/ml"

RUN chown -R kx:kx /opt/kx/ml1 
RUN mkdir /opt/kx/q/ml1
RUN find /opt/kx/ml1 -maxdepth 1 -type f -name '*.q' | xargs ln -s -t /opt/kx/q/ml1 \
        && ln -s -t /opt/kx/q/ml1 /opt/kx/ml1/fresh /opt/kx/ml1/utils

USER kx

RUN . /opt/conda/etc/profile.d/conda.sh \
        && conda activate kx \
        && conda install --file /opt/kx/ml1/requirements.txt \
        && conda clean -y --all 

USER root

ENTRYPOINT ["/init"]
CMD ["q", "ml1/init.q"]
